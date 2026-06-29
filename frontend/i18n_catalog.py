"""Catálogo de traducciones de CADU.

El sitio Sinatra usaba i18n con archivos YAML (`locales/es.yml`, `locales/en.yml`)
y llamadas `I18n.t 'clave'`. Para migrar las vistas SIN reescribir ni re-teclear las
~129 claves, reutilizamos esos mismos YAML tal cual y resolvemos las claves con el
template tag `{% t 'clave' %}`. Así la traducción es idéntica a la del Sinatra.
"""

import os

import yaml
from django.conf import settings

_CATALOG = None


def _load():
    global _CATALOG
    if _CATALOG is not None:
        return _CATALOG
    catalog = {}
    locales_dir = os.path.join(settings.BASE_DIR, "locales")
    for lang in ("es", "en"):
        path = os.path.join(locales_dir, f"{lang}.yml")
        try:
            with open(path, encoding="utf-8") as fh:
                data = yaml.safe_load(fh) or {}
            # Los YAML tienen una sola raíz (`es:` / `en:`) con pares planos.
            catalog[lang] = data.get(lang, {}) or {}
        except FileNotFoundError:
            catalog[lang] = {}
    _CATALOG = catalog
    return _CATALOG


def translate(key, lang="es"):
    """Devuelve la traducción de `key` para `lang`.

    Si la clave no existe (p. ej. cuando el Sinatra usaba un literal en vez de
    una clave I18n), se devuelve la propia clave/literal, igual que hacía I18n.t.
    """
    if not key:
        return ""
    lang = (lang or "es").split("-")[0]
    catalog = _load()
    table = catalog.get(lang) or catalog.get("es", {})
    return table.get(key, key)
