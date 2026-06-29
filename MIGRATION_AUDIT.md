# MIGRATION_AUDIT — CADU-v3

> Auditoría en **solo lectura** generada el 2026-06-09. No se modificó ningún archivo del proyecto (salvo la creación de este reporte).
>
> **Hallazgo principal:** Este **NO es una aplicación Rails**. Es una aplicación **Sinatra** (micrositio de Relación con Inversionistas, bilingüe ES/EN), de tipo *server-rendered* con plantillas ERB. Por ello, varias secciones solicitadas que asumen Rails (modelos ActiveRecord, `db/schema.rb`, `config/routes.rb`, `app/controllers`, ActiveStorage, base de datos relacional) **no existen** en este proyecto; se documenta a continuación qué hay realmente y se cita el archivo equivalente.

---

## 1. Versiones y gems

| Concepto | Valor | Fuente |
|---|---|---|
| Ruby | **3.2.6** (`3.2.6p234`) | `.ruby-version`, `Gemfile:2`, `Gemfile.lock` (RUBY VERSION) |
| Framework web | **Sinatra 4.0.0** (no Rails) | `Gemfile.lock` |
| Rack | 3.0.9 | `Gemfile.lock` |
| Bundler | 2.1.4 | `Gemfile.lock` (BUNDLED WITH) |
| Plataformas | `ruby`, `x64-mingw32`, `x86-mingw32` | `Gemfile.lock` (PLATFORMS) |

> **No hay Rails.** No existe `rails` ni `activerecord` en `Gemfile`/`Gemfile.lock`. No hay `config/application.rb`, `config/routes.rb`, `bin/rails` ni `Rakefile`.

### Gems del `Gemfile` y su propósito

| Gem | Versión (lock) | Propósito |
|---|---|---|
| `sinatra` | 4.0.0 | Framework web/DSL de rutas. Núcleo de la app (`app.rb`). |
| `i18n` | 1.14.1 | Internacionalización ES/EN. Cargado desde `locales/*.yml` (`app.rb:38-39`). |
| `pony` | 1.13.1 | Envío de correo SMTP (formulario de suscripción al boletín, `app.rb:108-123`, vía Mailgun). |
| `sentry-ruby` | 5.16.1 | Monitoreo de errores. Inicializado en `app.rb:51-53` (DSN hardcodeado — ver §8). |
| `firebase` | 0.2.8 | Cliente Firebase Realtime DB; guarda suscriptores en `iredge.firebaseio.com` (`app.rb:133-135`). |
| `recaptcha` | 5.16.0 | Verificación Google reCAPTCHA v3 del formulario (la verificación real se hace con `Net::HTTP` manual en `app.rb:88-105`, no con el helper de la gem). |
| `dotenv` | 3.0.0 | Carga variables de entorno desde `.env` (`require 'dotenv/load'` en `app.rb:6`). |
| `puma` | 6.4.2 | Servidor de aplicaciones (web server). |
| `rackup` | 2.1.0 | CLI/launcher de Rack 3 (`config.ru`). |
| `better_errors` | 2.10.1 | (dev) Página de errores enriquecida; middleware en `app.rb:9-10`. |
| `sinatra-contrib` | 4.0.0 | (dev) Extensiones de Sinatra. |
| `binding_of_caller` | 1.0.0 | (dev) Habilita el REPL/inspección de `better_errors`. |

Dependencias transitivas notables (de `Gemfile.lock`): `mail`, `net-smtp/imap/pop`, `faraday`, `googleauth`, `httpclient`, `jwt`, `tilt` (motor de plantillas), `mustermann` (matching de rutas), `rack-protection`, `rack-session`, `webrick`.

---

## 2. Tipo de aplicación

- **Monolito server-rendered** (no es API). Todas las rutas devuelven HTML renderizado con ERB y un layout común. Fuente: `app.rb` (todas las acciones llaman `erb :"...", :layout => "global/layouts/content"`).
- **Motor de plantillas:** **ERB** (vía `tilt`). No hay Haml ni Slim.
- **Conteo de vistas (`views/`, archivos `.erb`):** **131 archivos** `.erb` en total.
  - `views/es/` — versión en español.
  - `views/en/` — versión en inglés.
  - `views/global/bloques/` — parciales compartidos (header, footer, sidebar, head, recaptcha, mail, etc.).
  - `views/global/layouts/` — 2 layouts: `content.erb` (con sidebar de 3 columnas) y `content-full.erb`.
- Las vistas se organizan por menú: `menu1` (Nosotros), `menu2` (Gobierno corporativo / Sustentabilidad), `menu3` (Información financiera), `menu4` (Información bursátil), e `independientes` (sala-prensa, video, resultados, page-404, etc.).

> Nota: hay vistas que existen en `views/` pero **no tienen ruta** declarada en `app.rb` (p. ej. `menu3/reportes-trimestrales`, `menu3/reportes-anuales`, `menu3/teleconferencias`, `menu3/registros-sec`, `menu3/registros-otc`, `menu2/codigos-estatutos`, `menu4/bono`, `menu4/ibursatil`, `independientes/bolsa-trabajo`, `independientes/eventos-relevantes`, `terminos-condiciones`). Pueden estar enlazadas como parciales o ser código muerto. Ver §11.

---

## 3. Rutas

> No existe `config/routes.rb` (es Sinatra). Las rutas se definen como bloques `get`/`post` en **`app.rb`**. Resumen:

**Filtros / locale (`app.rb:21-74`):** un `before` define variables de instancia con rutas CDN (ver §6) y fuerza HTTPS en producción. Varios `before '/:locale...'` fijan `I18n.locale` a `es` o `en` (default `es`).

**Raíz e idioma:**
- `GET /` → `…/vistas/index` (home, español) — `app.rb:151`
- `GET /es`, `GET /en` → index en el idioma correspondiente — `app.rb:157,162`

**POST (única acción de escritura):**
- `POST /es/boletinsubscripcion` (`app.rb:76-147`): valida reCAPTCHA contra `google.com/recaptcha/api/siteverify`, envía correo de aviso vía `Pony`/Mailgun y guarda `{email}` en Firebase (`listas_distribucion/cadu/suscripcion/<name>`). Redirige a `/`.

**Menú 1 — Nosotros (`menuNum=1`):** `/:locale/estrategia`, `/modelo-negocio`, `/cadu-numeros`, `/panorama`, `/perfil`, `/directivos`, `/historia`.

**Menú 2 — Gobierno corporativo / Sustentabilidad (`menuNum=2`):** `/responsabilidad-social`, `/colaboradores`, `/comunidades`, `/valor_social`, `/medio-ambiente`, `/biodiversidad`, `/construccion_verde`, `/indicadores_ambientales`, `/politica_medio_ambiente`, `/residuos`, `/codigo_etica`, `/comite_etica`, `/sistema_denuncias`, `/politica_anticorrupcion`, `/estrategia_sustentabilidad`, `/comite_sustentabilidad`, `/estudio_materialidad`, `/objetivos_desarrollo_sostenible`, `/reporte_2017`, `/reporte_2018`, `/informes-sustentables`, `/informacion-corporativa`, `/auditor-externo`, `/estructura`, `/estructura-corporativa`, `/practicas`, `/comites`, `/consejo-administracion`, `/figuras_destacadas`.

**Menú 3 — Información financiera (`menuNum=3`):** `/comunicados`, `/fundamentales`, `/faqs`, `/glosario`, `/reportes-financieros`, `/presentaciones`.

**Menú 4 — Información bursátil (`menuNum=4`):** `/analistas`, `/calificaciones`, `/acuerdos-asambleas`, `/dividendos`, `/renta-fija-credito`, `/cotizacion`, `/prospectos`, `/calculadora`.

**Independientes (`menuNum=0`):** `/:locale/sala-prensa`, `/:locale/resultados`, `/:locale/video` (usa layout `content-full`).

**Manejo de errores:** `error do` → 500 renderiza `page-404`; `not_found do` → 404 renderiza `page-404` (`app.rb:169-179`). `GET /testerror` provoca `1/0` para probar Sentry (`app.rb:545`).

**Helper:** `change_language` (`app.rb:558-569`) alterna la URL actual entre `/es` y `/en`.

Bloques comentados (rutas desactivadas): `/:locale/codigos-estatutos` (`app.rb:231-236`) y `/:locale/terminos-condiciones` (`app.rb:549-553`).

---

## 4. Modelos

**No existen modelos.** No hay directorio `app/models/` ni clases de dominio/ORM. La aplicación no tiene capa de modelos: los datos se escriben directamente en las plantillas ERB (listas de comunicados, calificaciones, reportes, etc. están *hardcodeados* como arreglos Ruby dentro de las vistas, p. ej. `views/es/vistas/independientes/sala-prensa.erb`). El único almacenamiento estructurado es Firebase para suscriptores del boletín (ver §3, §6).

---

## 5. Controladores

**No existen controladores.** No hay `app/controllers/`. En Sinatra, toda la lógica de manejo de peticiones vive en los bloques de ruta de **`app.rb`** (descritos en §3). El único bloque con lógica de negocio real (no solo render) es `POST /es/boletinsubscripcion` (validación reCAPTCHA + correo + persistencia en Firebase). El resto de rutas solo fijan `@titulo`, `@menuNum`, `@menuName` y renderizan una vista ERB.

---

## 6. Archivos, imágenes y documentos (almacenamiento)

**No usa ActiveStorage, CarrierWave ni Paperclip** — ninguno aparece en `Gemfile`/`Gemfile.lock`. **No hay subida de archivos** en la app; todos los documentos (PDFs de reportes, comunicados, calificaciones, presentaciones) se referencian como **URLs directas a un CDN/S3 externo**.

### No hay configuración de S3 ni gem de AWS
- **No existe** `config/storage.yml` ni initializers de AWS.
- **No hay** gems `aws-sdk-*` ni `fog` en el bundle.
- **No hay credenciales de AWS** en el código (`grep` de `s3|aws|amazonaws` solo encuentra URLs en las vistas, ver abajo).

### Cómo se "generan" las URLs (en realidad, se hardcodean)
1. **Variables de prefijo CDN** definidas en el `before` global de `app.rb:27-33`:
   - `@investor_cloud_path = "http://cdn.investorcloud.net/cadu/"`
   - `@gobierno_corporatico_path = ".../cadu/GobiernoCorporativo/"`
   - `@comunicados_path = ".../cadu/Comunicados/"`
   - `@reportes_anuales_path = ".../cadu/InformacionFinanciera/ReportesAnuales/"`
   - `@reportes_trimestrales_path = ".../cadu/InformacionFinanciera/ReportesTrimestrales/"`
   - `@presentaciones_path = ".../cadu/Presentaciones/"`
   - `@registros_bmv_path = ""` (vacío)

   Estas variables se concatenan con nombres de archivo dentro de las vistas ERB para construir los enlaces de descarga.

2. **URLs S3 directas hardcodeadas** en las vistas (sin pasar por las variables). Conviven dos formatos de host (virtual-hosted y path-style) apuntando al mismo bucket `investorcloud`:
   - `https://investorcloud.s3.amazonaws.com/cadu/...` — p. ej. `views/es/vistas/menu4/calificaciones.erb`, `views/es/vistas/index.erb:108`, `views/es/vistas/menu2/etica/codigo_etica.erb:10`.
   - `https://s3.amazonaws.com/investorcloud/cadu/...` — p. ej. `views/es/vistas/independientes/sala-prensa.erb:156`.

   En total hay **~699 referencias** a `cdn.investorcloud.net`/`investorcloud`/`s3` entre `app.rb` y las vistas.

### Dónde viven los assets
- **Documentos (PDF, etc.):** externos, en el CDN `cdn.investorcloud.net` y el bucket S3 `investorcloud` (carpeta `cadu/`). **No están en el repositorio.**
- **Imágenes/medios estáticos del sitio:** en `public/` dentro del repo (ver §10).

> Implicación para migración: el bucket S3 `investorcloud` y el CDN `cdn.investorcloud.net` son **infraestructura de un tercero (InvestorCloud / IRStrat)**, no gestionada por esta app. Migrar el código no migra esos archivos; las URLs son absolutas y seguirán apuntando al mismo origen salvo que se reescriban masivamente en las vistas.

---

## 7. Base de datos

**No hay base de datos relacional.** No existe `config/database.yml`, ni `db/`, ni `db/schema.rb`, ni `seeds.rb`, ni migraciones. La app no usa SQL.

- **Único almacén de datos persistente:** Firebase Realtime Database en `https://iredge.firebaseio.com`, usado solo para guardar suscriptores del boletín (`app.rb:133-135`).
- **Contenido del sitio:** estático, embebido en las plantillas ERB y en archivos `public/`. No hay "datos de producción vs. seeds" porque no hay esquema.

---

## 8. Variables de entorno y secretos

### `ENV[...]` referenciados (todos en `app.rb`, dentro de `POST /es/boletinsubscripcion`)
- `ENV['RECAPTCHA_SECRET_KEY']` — `app.rb:92`
- `ENV['EMAIL_HOST_USER']` — `app.rb:119`
- `ENV['EMAIL_HOST_PASSWORD']` — `app.rb:120`

Se cargan vía `dotenv` desde un archivo `.env` (presente en `.gitignore`, **no versionado**; no hay `.env.example`).

### ⚠️ Secretos hardcodeados en el código (riesgo)
- **DSN de Sentry** con clave pública+privada embebida en `app.rb:52` (y duplicado comentado de Raven en `app.rb:46,52`).
- **Credenciales de correo** del formulario: remitente `it@investorcloud.net`, SMTP `smtp.mailgun.org:587`, dominio `irstrat.com` (`app.rb:106-123`).
- **Endpoint Firebase** `iredge.firebaseio.com` hardcodeado (`app.rb:133`). El cliente Firebase se instancia **sin token de auth** (`Firebase::Client.new(firebase_uri)` sin segundo argumento), lo que implica reglas de DB abiertas o que dependía de auth heredada.

No se usa `Rails.application.credentials` (no es Rails).

---

## 9. Despliegue

**No hay artefactos de despliegue en el repo:**
- **No existe** `Procfile`.
- **No existe** `Dockerfile` ni `docker-compose.yml`.
- **No existe** `Capfile`/Capistrano ni configuración de Heroku.

Pistas de ejecución disponibles:
- `config.ru` — entrypoint Rack: `require app.rb` + `run Sinatra::Application`. Se levanta con `rackup` / `puma`.
- `app.rb:40-41` — `set :port, 3008`, `set :bind, '0.0.0.0'`.
- `app.rb:16-18` — en producción fuerza SSL (`force_ssl`), redirigiendo `http→https`.
- No hay configuración de CI (`.github/`, etc.) ni scripts de deploy en el árbol.

> El método de despliegue real **no es determinable** desde el repositorio (ver §11).

---

## 10. Assets front-end

- **Sistema de assets:** **ninguno de Rails.** No usa Sprockets, Webpacker ni importmap (no hay gems ni `app/assets`, `app/javascript`, `config/importmap.rb`). Sinatra sirve la carpeta **`public/`** como estática directamente; las vistas referencian rutas absolutas tipo `/assets/...` y `/favicon.png` (ver `views/global/bloques/head.erb`).
- **CSS:** **112 archivos `.css`** ya compilados en `public/assets/...` (Bootstrap, plugins, temas, `custom.css`, `ajustes-jc.css`). Además hay **fuentes SCSS** (204 `.scss`) en `public/sass/` (variables, mixins, temas, plugins) que parecen el **origen** de los temas, pero **no hay pipeline de compilación configurado en la app** — el CSS servido es el ya generado en `public/assets/base/css/`.
- **JS:** **124 archivos `.js`** en `public/assets/` (jQuery + migrate, Bootstrap, amCharts, owl-carousel, fancybox, pace, wow, datepicker, y scripts propios: `app.js`, `calculadora.js`, `dataDistribucion.js`, `charts-*.js`). Se incluyen vía `views/global/bloques/javascript.erb` y `head.erb`.
- **Imágenes y medios:** en `public/` — inventario por extensión: **1,194 `.jpg`**, **561 `.png`**, **93 `.svg`**, **84 `.eps`**, **30 `.gif`**, **3 `.mp4`**, fuentes (`woff/woff2/ttf/eot/otf`), más `61 .html` (fragmentos AJAX en `public/ajax/`) y algunos `.php`/`.json`/`.psd` de plantilla. Imágenes del sitio principalmente bajo `public/assets/cadu/images/`.
- **Fuentes externas:** Google Fonts (Roboto Condensed) vía `<link>` en `head.erb:10`.

---

## 11. Lo que NO se pudo determinar (con certeza, desde el repo)

1. **Método/host de despliegue real.** No hay `Procfile`, `Dockerfile`, Capistrano, ni config de Heroku/PaaS. Solo se sabe que corre como app Rack/Puma en el puerto 3008 con SSL forzado en producción.
2. **Valores de las variables de entorno** (`RECAPTCHA_SECRET_KEY`, `EMAIL_HOST_USER`, `EMAIL_HOST_PASSWORD`): el `.env` no está versionado y no hay `.env.example`.
3. **Autenticación/credenciales de Firebase.** El cliente se crea sin token; no se puede saber desde el repo si la DB es pública o si dependía de credenciales externas/reglas del proyecto `iredge`.
4. **Propiedad y contenido del bucket S3 `investorcloud` / CDN `cdn.investorcloud.net`.** Son externos; no se puede inventariar ni confirmar qué documentos existen, ni si están versionados/respaldados.
5. **Rutas/vistas "huérfanas".** Hay ~11 vistas `.erb` sin ruta declarada en `app.rb` (reportes-trimestrales, reportes-anuales, teleconferencias, registros-sec/otc, bono, ibursatil, bolsa-trabajo, eventos-relevantes, terminos-condiciones, codigos-estatutos, snippet). No se puede confirmar desde el repo si son código muerto o se incluyen como parciales desde otras vistas.
6. **Estrategia de compilación de SCSS→CSS.** Existen fuentes `.scss` en `public/sass/` y CSS compilado en `public/assets/base/css/`, pero no hay herramienta/configuración de build en el repo; no se determina cómo se regeneran los temas.
7. **Versión/entorno de Ruby en producción** más allá de `.ruby-version` (3.2.6); no hay manifiesto de plataforma de hosting.
