"""
Django settings for the CADU project.

Sitio de Relación con Inversionistas de CADU, migrado de Sinatra a Django.
App mínima: sin base de datos, sin modelos, sin admin (ver MIGRATION_AUDIT.md).

La organización de este archivo sigue el "house style" de IRStrat tomado del
proyecto Montepío (rieduca/settings.py): mismo manejo de estáticos (WhiteNoise +
CompressedStaticFilesStorage, WHITENOISE_MANIFEST_STRICT = False), carga de .env
con python-dotenv, i18n con LocaleMiddleware, e idiomas es/en (es por defecto).
"""

import os
from pathlib import Path

import sentry_sdk
from django.utils.translation import gettext_lazy as _
from dotenv import load_dotenv

load_dotenv(Path(__file__).resolve().parent.parent / ".env")

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get(
    "DJANGO_SECRET_KEY",
    "dev-only-fallback-key-do-not-use-in-production-change-me-please-cadu",
)

# Secretos del formulario de boletín de CADU (referenciados en app.rb del Sinatra).
# NO se hardcodean: vienen del entorno (.env). Ver .env.example.
RECAPTCHA_SECRET_KEY = os.getenv("RECAPTCHA_SECRET_KEY")

# Correo del aviso de suscripción (Mailgun SMTP, igual que el Pony del Sinatra).
# El host/puerto son configuración (no secretos); usuario/clave SÍ son secretos (env).
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_HOST = os.getenv("EMAIL_HOST", "smtp.mailgun.org")
EMAIL_PORT = int(os.getenv("EMAIL_PORT", "587"))
EMAIL_USE_TLS = True
EMAIL_HOST_USER = os.getenv("EMAIL_HOST_USER")
EMAIL_HOST_PASSWORD = os.getenv("EMAIL_HOST_PASSWORD")
# Remitente/destinatario del aviso (eran literales en app.rb; aquí configurables).
NEWSLETTER_FROM = os.getenv("NEWSLETTER_FROM", "it@investorcloud.net")
NEWSLETTER_TO = os.getenv("NEWSLETTER_TO", "it@irstrat.com")

# Firebase Realtime DB (suscriptores). CAMBIO vs el Sinatra: escritura CON token
# server-side (FIREBASE_TOKEN) en vez del write sin auth, para poder cerrar las
# reglas de la DB. Si el token no está configurado, la escritura se omite (se loguea).
FIREBASE_URL = os.getenv("FIREBASE_URL")
FIREBASE_TOKEN = os.getenv("FIREBASE_TOKEN")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.environ.get("DEBUG", "False").lower() == "true"

ALLOWED_HOSTS = ["*"]

# Application definition
# App mínima: solo staticfiles (para WhiteNoise/collectstatic) + la app frontend.
# Sin admin/auth/sessions/messages porque la app es server-rendered sin BD.
INSTALLED_APPS = [
    "django.contrib.staticfiles",
    "frontend.apps.FrontendConfig",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    # WhiteNoise justo después de SecurityMiddleware (igual que la config que
    # django-heroku inyecta en Montepío) para servir estáticos en producción.
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "django.middleware.locale.LocaleMiddleware",
    "django.middleware.common.CommonMiddleware",
    # CSRF: el Sinatra no lo tenía; Django lo exige para el POST del boletín.
    "django.middleware.csrf.CsrfViewMiddleware",
]

ROOT_URLCONF = "cadu.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.template.context_processors.i18n",
                "frontend.context_processors.cdn_paths",
            ],
        },
    },
]

WSGI_APPLICATION = "cadu.wsgi.application"

# Sin base de datos: la app es 100% server-rendered estática (ver MIGRATION_AUDIT.md).
DATABASES = {}

# Internationalization
LANGUAGE_CODE = "es"
TIME_ZONE = "UTC"
USE_I18N = True
USE_TZ = True

LANGUAGES = [
    ("es", _("Spanish")),
    ("en", _("English")),
]

# Static files (CSS, JavaScript, Images)
# Copia íntegra de public/ del Sinatra dentro de frontend/static (servida por WhiteNoise).
STATIC_URL = "/static/"
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")

# Mecanismo de estáticos idéntico a Montepío: WhiteNoise comprimido SIN manifiesto
# (los nombres de archivo NO se hashean, por lo que las rutas /static/... son estables).
STATICFILES_STORAGE = "whitenoise.storage.CompressedStaticFilesStorage"
WHITENOISE_MANIFEST_STRICT = False

# HTTPS forzado solo en producción (réplica del `configure :production` de app.rb).
SECURE_SSL_REDIRECT = os.getenv("SECURE_SSL_REDIRECT", "False").lower() == "true"

# Sentry: DSN desde el entorno (NUNCA hardcodeado, a diferencia del Sinatra).
SENTRY_DSN = os.getenv("SENTRY_DSN")
if SENTRY_DSN:
    sentry_sdk.init(dsn=SENTRY_DSN, traces_sample_rate=0.0)

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
        },
    },
    "root": {
        "handlers": ["console"],
        "level": "WARNING",
    },
}

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"
