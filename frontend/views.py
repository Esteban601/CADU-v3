"""Vistas de CADU.

Dos vistas cubren todo el sitio server-rendered:
- `home`: la portada (plantilla standalone por idioma, sin layout base; igual que
  el `get '/'` del Sinatra, que renderizaba index sin layout).
- `page`: vista genérica data-driven que sirve cualquier slug del mapa ROUTES.
"""

import logging

import requests
from django.conf import settings
from django.core.mail import EmailMessage, get_connection
from django.http import Http404
from django.shortcuts import redirect, render
from django.template import TemplateDoesNotExist
from django.template.loader import get_template, render_to_string
from django.utils.translation import get_language
from django.views.decorators.http import require_POST

from .data import DOCUMENTS
from .i18n_catalog import translate
from .routes import ROUTES

log = logging.getLogger(__name__)

# Vistas solo-ES en el original (no existe fuente EN): /en/<slug> redirige a /es/<slug>.
EN_REDIRECT_TO_ES = {"calculadora", "resultados"}


def home(request):
    lang = (get_language() or "es").split("-")[0]
    # El Sinatra fijaba @titulo solo para la home en español.
    titulo = "Relación con inversionistas" if lang == "es" else ""
    return render(request, f"frontend/{lang}/index.html", {"titulo": titulo})


def page(request, *args, **kwargs):
    slug = request.resolver_match.url_name
    route = ROUTES.get(slug)
    if route is None:
        raise Http404(slug)

    lang = (get_language() or "es").split("-")[0]

    # Vistas solo-ES: en EN no hay plantilla, redirigimos a la versión ES.
    if lang == "en" and slug in EN_REDIRECT_TO_ES:
        return redirect(f"/es/{slug}")

    context = {
        "titulo": translate(route.get("titulo"), lang),
        "menu_num": route.get("menu_num", 0),
        "menu_name": translate(route.get("menu_name"), lang),
        "historia": route.get("historia", False),
    }

    # Listas de documentos extraídas de los arreglos Ruby @documents (sala-prensa,
    # comunicados). Se pasan a la plantilla para el {% for %}; la plantilla arma
    # los enlaces con las variables CDN del context processor.
    docs = DOCUMENTS.get(slug, {}).get(lang)
    if docs is not None:
        context["documents"] = docs

    template = f"frontend/{lang}/vistas/{route['tpl']}.html"
    try:
        get_template(template)
    except TemplateDoesNotExist:
        # Página aún no convertida en este bloque (solo se convirtió la home).
        # Renderizamos el chrome real (header, breadcrumbs, sidebar, footer) con un
        # aviso, para validar end-to-end el layout base y los parciales.
        layout = route.get("layout", "content")
        context["layout_template"] = f"layouts/{layout}.html"
        context["slug"] = slug
        return render(request, "frontend/_pending.html", context)

    return render(request, template, context)


# ---------------------------------------------------------------------------
# Formulario de boletín — reimplementa el handler Sinatra de app.rb:76-147.
# Mismo endpoint que postea el markup del footer (/es/boletinsubscripcion).
# ---------------------------------------------------------------------------
RECAPTCHA_VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify"


def _verify_recaptcha(token):
    """reCAPTCHA v3 contra Google siteverify (success && score >= 0.5)."""
    secret = settings.RECAPTCHA_SECRET_KEY
    if not secret:
        log.warning("RECAPTCHA_SECRET_KEY no configurado; se omite verificación.")
        return False
    resp = requests.post(
        RECAPTCHA_VERIFY_URL,
        data={"secret": secret, "response": token},
        timeout=10,
    )
    data = resp.json()
    return data.get("success") is True and data.get("score", 0) >= 0.5


def _send_subscription_email(request, email):
    """Aviso de nuevo suscriptor vía Mailgun SMTP (equivale al Pony.mail)."""
    if not (settings.EMAIL_HOST_USER and settings.EMAIL_HOST_PASSWORD):
        log.warning("Credenciales SMTP ausentes; se omite el envío de correo.")
        return
    body = render_to_string("emails/boletin.html", {"email": email})
    connection = get_connection()  # usa EMAIL_* de settings
    msg = EmailMessage(
        subject="Nuevo subscriptor a lista CADU",
        body=body,
        from_email=settings.NEWSLETTER_FROM,
        to=[settings.NEWSLETTER_TO],
        connection=connection,
    )
    msg.content_subtype = "html"
    msg.send(fail_silently=False)


def _write_firebase(email):
    """Escribe el suscriptor en Firebase por REST CON token server-side.

    CAMBIO deliberado vs el Sinatra (que escribía SIN auth): se manda ?auth=TOKEN
    para poder cerrar las reglas. Si no hay URL/token, se omite y se loguea.
    """
    if not settings.FIREBASE_URL:
        log.warning("FIREBASE_URL no configurada; se omite la escritura.")
        return
    # Nombre derivado del email igual que el Sinatra (sin '@' ni '.').
    name = "".join(c for c in email if c not in "@.")
    url = f"{settings.FIREBASE_URL.rstrip('/')}/listas_distribucion/cadu/suscripcion/{name}.json"
    params = {}
    if settings.FIREBASE_TOKEN:
        params["auth"] = settings.FIREBASE_TOKEN
    else:
        log.warning("FIREBASE_TOKEN no configurado; escritura sin auth (cerrar reglas pendiente).")
    requests.put(url, json={"email": email}, params=params, timeout=10)


@require_POST
def boletin(request):
    """POST /es/boletinsubscripcion — suscripción al boletín financiero."""
    token = request.POST.get("g_recaptcha_response", "")
    if token == "":
        return redirect("/")
    try:
        if not _verify_recaptcha(token):
            return redirect("/")
        email = request.POST.get("email", "")
        if email:
            _send_subscription_email(request, email)
            _write_firebase(email)
    except Exception:  # noqa: BLE001 — nunca romper la UX del formulario
        log.exception("Error procesando la suscripción al boletín")
    return redirect("/")


# ---------------------------------------------------------------------------
# Manejadores de error (fuera de ROUTES). Portan el page-404 del Sinatra.
# ---------------------------------------------------------------------------
def error_404(request, exception=None):
    return render(
        request,
        "404.html",
        {"titulo": "Error 404", "menu_num": 0, "menu_name": ""},
        status=404,
    )


def error_500(request):
    # Plantilla autocontenida (sin context processors ni includes) por robustez.
    return render(request, "500.html", status=500)
