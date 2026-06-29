"""Context processors globales de CADU.

Expone las variables de prefijo CDN definidas en el `before` global del Sinatra
(app.rb:27-33) como contexto disponible en todas las plantillas. Las URLs
absolutas a s3 / cdn.investorcloud.net que están hardcodeadas en las vistas se
conservan TAL CUAL; estas variables replican las que el Sinatra dejaba en @ivars.
"""


def cdn_paths(request):
    return {
        "investor_cloud_path": "http://cdn.investorcloud.net/cadu/",
        "gobierno_corporatico_path": "http://cdn.investorcloud.net/cadu/GobiernoCorporativo/",
        "comunicados_path": "http://cdn.investorcloud.net/cadu/Comunicados/",
        "reportes_anuales_path": "http://cdn.investorcloud.net/cadu/InformacionFinanciera/ReportesAnuales/",
        "reportes_trimestrales_path": "http://cdn.investorcloud.net/cadu/InformacionFinanciera/ReportesTrimestrales/",
        "registros_bmv_path": "",
        "presentaciones_path": "http://cdn.investorcloud.net/cadu/Presentaciones/",
    }
