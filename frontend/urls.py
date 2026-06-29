from django.urls import path

from . import views
from .routes import ROUTES

urlpatterns = [
    path("", views.home, name="index"),
    # POST del boletín (mismo endpoint que postea el markup: /es/boletinsubscripcion).
    path("boletinsubscripcion", views.boletin, name="boletinsubscripcion"),
]

# Una sola vista genérica sirve todas las rutas del mapa data-driven (ROUTES).
# El nombre de cada URL coincide con su slug, de modo que `{% change_language %}`
# pueda hacer reverse() al alternar es/en.
urlpatterns += [path(slug, views.page, name=slug) for slug in ROUTES]
