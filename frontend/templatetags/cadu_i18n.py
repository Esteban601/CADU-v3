"""Template tags de CADU: `{% t %}` y `{% change_language %}`.

- `t`  reemplaza las llamadas `<%= I18n.t 'clave' %>` del ERB usando el mismo
  catálogo YAML del Sinatra (ver frontend/i18n_catalog.py).
- `change_language` reimplementa el helper `change_language` de app.rb:558-569:
  devuelve la URL de la página actual en el OTRO idioma. Sigue el mismo patrón
  resolve()/reverse() que el house style de Montepío (change_languaje.py).
"""

from django import template
from django.urls import Resolver404, resolve, reverse
from django.utils.translation import activate, get_language

from frontend.i18n_catalog import translate

register = template.Library()


@register.simple_tag(takes_context=True)
def t(context, key):
    """Traduce `key` con el idioma activo (equivalente a I18n.t)."""
    request = context.get("request")
    lang = getattr(request, "LANGUAGE_CODE", None) or get_language() or "es"
    return translate(key, lang)


@register.simple_tag(takes_context=True)
def change_language(context):
    """Devuelve la URL actual en el idioma opuesto (es <-> en)."""
    request = context["request"]
    cur = (get_language() or "es").split("-")[0]
    target = "en" if cur == "es" else "es"
    full_path = request.get_full_path()
    try:
        match = resolve(request.path)
        try:
            activate(target)
            url = reverse(match.view_name, args=match.args, kwargs=match.kwargs)
        finally:
            activate(cur)
        query = full_path.split("?", 1)
        return url + ("?" + query[1] if len(query) == 2 else "")
    except Resolver404:
        return full_path
