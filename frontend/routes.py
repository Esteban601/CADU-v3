"""Mapa de rutas data-driven de CADU.

Replica las rutas del Sinatra (MIGRATION_AUDIT.md §3 / app.rb). Cada entrada:

    slug: (template_relativo, titulo, menu_num, menu_name, **flags)

- template_relativo: ruta bajo `frontend/<lang>/vistas/` SIN extensión.
- titulo / menu_name: clave i18n (resuelta con el catálogo; si no es clave, se
  usa el literal tal cual, igual que hacía `I18n.t`).
- menu_num: resalta el menú activo (0 = páginas sueltas).
- flags opcionales: layout="content-full", historia=True.

Una sola vista genérica (`views.page`) sirve todas estas rutas.
"""

# slug -> dict(tpl, titulo, menu_num, menu_name, layout?, historia?)
ROUTES = {
    # ---- Menú 1: Nosotros ----
    "estrategia": dict(tpl="menu1/estrategia", titulo="Estrategia", menu_num=1, menu_name="Nosotros"),
    "modelo-negocio": dict(tpl="menu1/modelo-negocio", titulo="modelo_n", menu_num=1, menu_name="Nosotros"),
    "cadu-numeros": dict(tpl="menu1/cadu-numeros", titulo="Cadu en números", menu_num=1, menu_name="Nosotros"),
    "panorama": dict(tpl="menu1/panorama", titulo="Panorama", menu_num=1, menu_name="Nosotros"),
    "perfil": dict(tpl="menu1/perfil", titulo="Perfil", menu_num=1, menu_name="Nosotros"),
    "directivos": dict(tpl="menu1/directivos", titulo="Directivos", menu_num=1, menu_name="Nosotros"),
    "historia": dict(tpl="menu1/historia", titulo="Historia", menu_num=1, menu_name="Nosotros", historia=True),

    # ---- Menú 2: Sustentabilidad / Gobierno corporativo ----
    "responsabilidad-social": dict(tpl="menu2/responsabilidad-social", titulo="responsabilidad_s", menu_num=2, menu_name="sustentabilidad"),
    "colaboradores": dict(tpl="menu2/responsabilidad_social/colaboradores", titulo="colaboradores", menu_num=2, menu_name="sustentabilidad"),
    "comunidades": dict(tpl="menu2/responsabilidad_social/comunidades", titulo="comunidades", menu_num=2, menu_name="sustentabilidad"),
    "valor_social": dict(tpl="menu2/responsabilidad_social/valor_social", titulo="valor_social_compartido", menu_num=2, menu_name="sustentabilidad"),
    "medio-ambiente": dict(tpl="menu2/medio-ambiente", titulo="medio_a", menu_num=2, menu_name="sustentabilidad"),
    "biodiversidad": dict(tpl="menu2/medio_ambiente/biodiversidad", titulo="biodiversidad", menu_num=2, menu_name="medio_a"),
    "construccion_verde": dict(tpl="menu2/medio_ambiente/construccion_verde", titulo="construccion_verde", menu_num=2, menu_name="medio_a"),
    "indicadores_ambientales": dict(tpl="menu2/medio_ambiente/indicadores_ambientales", titulo="indicadores_ambientales", menu_num=2, menu_name="medio_a"),
    "politica_medio_ambiente": dict(tpl="menu2/medio_ambiente/politica_medio", titulo="politica_medio_ambiente", menu_num=2, menu_name="medio_a"),
    "residuos": dict(tpl="menu2/medio_ambiente/residuos", titulo="residuos", menu_num=2, menu_name="medio_a"),
    "codigo_etica": dict(tpl="menu2/etica/codigo_etica", titulo="codigo_etica", menu_num=2, menu_name="etica"),
    "comite_etica": dict(tpl="menu2/etica/comite_etica", titulo="comite_etica", menu_num=2, menu_name="etica"),
    "sistema_denuncias": dict(tpl="menu2/etica/sistema_denuncias", titulo="sistema_denuncias", menu_num=2, menu_name="etica"),
    "politica_anticorrupcion": dict(tpl="menu2/etica/politica_anticorrupcion", titulo="politica_anticorrupcion", menu_num=2, menu_name="etica"),
    "estrategia_sustentabilidad": dict(tpl="menu2/estrategia_modelo/estrategia_sustentabilidad", titulo="estrategia_sustentabilidad", menu_num=2, menu_name="estrategia_modelo"),
    "comite_sustentabilidad": dict(tpl="menu2/estrategia_modelo/comite", titulo="comite_sustentabilidad", menu_num=2, menu_name="estrategia_modelo"),
    "estudio_materialidad": dict(tpl="menu2/estrategia_modelo/estudio_materialidad", titulo="estudio_materialidad", menu_num=2, menu_name="estrategia_modelo"),
    "objetivos_desarrollo_sostenible": dict(tpl="menu2/objetivos_desarrollo", titulo="objetivos_desarrollo_sostenible", menu_num=2, menu_name="sustentabilidad"),
    "reporte_2017": dict(tpl="menu2/reporte_2017", titulo="reporte_2017", menu_num=2, menu_name="sustentabilidad"),
    "reporte_2018": dict(tpl="menu2/reporte_2018", titulo="reporte_2018", menu_num=2, menu_name="sustentabilidad"),
    "informes-sustentables": dict(tpl="menu2/informes-sustentables", titulo="informe_s", menu_num=2, menu_name="sustentabilidad"),
    "informacion-corporativa": dict(tpl="menu2/informacion-corporativa", titulo="Información corporativa", menu_num=2, menu_name="Gobierno_corporativo"),
    "auditor-externo": dict(tpl="menu2/auditor-externo", titulo="Auditor_externo", menu_num=2, menu_name="Gobierno_corporativo"),
    "estructura": dict(tpl="menu2/estructura-accionaria", titulo="Estructura_accionaria", menu_num=2, menu_name="Gobierno_corporativo"),
    "estructura-corporativa": dict(tpl="menu2/estructura-corporativa", titulo="estructura_c", menu_num=2, menu_name="Gobierno_corporativo"),
    "practicas": dict(tpl="menu2/practicas", titulo="practicas", menu_num=2, menu_name="Gobierno_corporativo"),
    "comites": dict(tpl="menu2/comites", titulo="Comites", menu_num=2, menu_name="Gobierno_corporativo"),
    "consejo-administracion": dict(tpl="menu2/consejo-administracion", titulo="Consejo_de_Administracion", menu_num=2, menu_name="Gobierno_corporativo"),
    "figuras_destacadas": dict(tpl="menu2/figuras_destacadas", titulo="figuras_destacadas", menu_num=2, menu_name="Gobierno_corporativo"),

    # ---- Menú 3: Información financiera ----
    "comunicados": dict(tpl="menu3/comunicados", titulo="comunicados", menu_num=3, menu_name="Informacion_financiera"),
    "fundamentales": dict(tpl="menu3/fundamentales", titulo="Fundamentales", menu_num=3, menu_name="Informacion_financiera"),
    "faqs": dict(tpl="menu3/faqs", titulo="Preguntas_frecuentes", menu_num=3, menu_name="Informacion_financiera"),
    "glosario": dict(tpl="menu3/glosario", titulo="Glosario", menu_num=3, menu_name="Informacion_financiera"),
    "reportes-financieros": dict(tpl="menu3/reportes-financieros", titulo="reportes_f", menu_num=3, menu_name="Informacion_financiera"),
    "presentaciones": dict(tpl="menu3/presentaciones", titulo="presentaciones", menu_num=3, menu_name="Informacion_financiera"),

    # ---- Menú 4: Información bursátil ----
    "analistas": dict(tpl="menu4/analistas", titulo="Cobertura_de_analistas", menu_num=4, menu_name="Informacion_bursatil"),
    "calificaciones": dict(tpl="menu4/calificaciones", titulo="Calificaciones", menu_num=4, menu_name="Informacion_bursatil"),
    "acuerdos-asambleas": dict(tpl="menu4/acuerdos-asambleas", titulo="acuerdos_a", menu_num=4, menu_name="Informacion_bursatil"),
    "dividendos": dict(tpl="menu4/dividendos", titulo="dividendos", menu_num=4, menu_name="Informacion_bursatil"),
    "renta-fija-credito": dict(tpl="menu4/renta-fija-credito", titulo="renta_f", menu_num=4, menu_name="Informacion_bursatil"),
    "cotizacion": dict(tpl="menu4/cotizacion", titulo="Cotizacion_de_la_accion", menu_num=4, menu_name="Informacion_bursatil"),
    "prospectos": dict(tpl="menu4/prospectos", titulo="Prospectos", menu_num=4, menu_name="Informacion_bursatil"),
    "calculadora": dict(tpl="menu4/calculadora", titulo="Calculadora de Rendimientos", menu_num=4, menu_name="Informacion_bursatil"),

    # ---- Páginas sueltas (menu_num=0) ----
    "sala-prensa": dict(tpl="independientes/sala-prensa", titulo="Sala", menu_num=0, menu_name="Sala"),
    "resultados": dict(tpl="independientes/resultados", titulo="Resultados", menu_num=0, menu_name=""),
    "video": dict(tpl="independientes/video", titulo="Video corporativo", menu_num=0, menu_name="", layout="content-full"),
}
