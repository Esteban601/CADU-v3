"""URL configuration for the CADU project.

i18n_patterns expone el sitio bajo /es/ y /en/ (réplica de las rutas /es y /en
del Sinatra). prefix_default_language=True hace que `/` redirija a `/es/`, de modo
que la home queda accesible en `/`, `/es` y `/en`.
"""

from django.conf.urls.i18n import i18n_patterns
from django.urls import include, path
from django.views.generic.base import RedirectView

# Fix de ruteo (sin tocar los assets): algunos JS de plugins (amCharts dashboard.js /
# dashboard-en.js, `chart.pathToImages = "/assets/plugins/amcharts/images/"`) piden
# rutas absolutas bajo /assets/. Se sirven redirigiendo a /static/assets/<path>, que
# es donde WhiteNoise/staticfiles tienen las imágenes. NO se reescribe ningún archivo.
urlpatterns = [
    path(
        "assets/<path:path>",
        RedirectView.as_view(url="/static/assets/%(path)s", permanent=False, query_string=True),
    ),
]

# Estáticos del sitio: en DEBUG los sirve django.contrib.staticfiles (runserver) desde
# frontend/static; en producción los sirve WhiteNoise desde STATIC_ROOT.
urlpatterns += i18n_patterns(
    path("", include("frontend.urls")),
    prefix_default_language=True,
)

# Manejadores de error (portan el page-404 del Sinatra; fuera de ROUTES).
handler404 = "frontend.views.error_404"
handler500 = "frontend.views.error_500"
