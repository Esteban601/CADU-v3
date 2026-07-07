# DEPLOY — CADU (caducancun)

## 1. Estado

**`caducancun` corre Django/Python desde 2026-07-07.**

- Release: **v970**
- Proceso web: `gunicorn cadu.wsgi`
- Buildpack: `heroku/python`
- El sitio **Ruby/Sinatra quedó retirado** (ya no se sirve).

Repo de deploy: **CADU-v3** (Django). Dominios en producción:
`ri.caduinmobiliaria.com`, `cadu.investorcloud.net`, `caducancun.herokuapp.com`.

---

## 2. ⚠️ ADVERTENCIA ⚠️

> # 🚨 NO PUSHEAR EL REPO RUBY VIEJO A `caducancun` 🚨
>
> **Pushear desde el proyecto Ruby/Sinatra antiguo CRASHEA PRODUCCIÓN.**
> El buildpack es `heroku/python` y el proceso es `gunicorn cadu.wsgi`;
> un slug Ruby no arranca y tumba el sitio.
>
> **TODOS los deploys de `caducancun` salen de este repo: `CADU-v3` (Django).**

---

## 3. Config vars requeridas (nombres, no valores)

| Variable | Propósito |
|---|---|
| `DJANGO_SECRET_KEY` | Llave secreta de Django (firma de sesiones/CSRF). Debe ser una llave real y secreta, **no** el fallback de `settings.py`. |
| `DEBUG` | `False` en producción. Cualquier valor distinto de `true` (case-insensitive) = desactivado. |
| `ALLOWED_HOSTS` | Dominios permitidos. **Formato: separados por comas, SIN espacios.** Valor de prod: `ri.caduinmobiliaria.com,cadu.investorcloud.net,caducancun.herokuapp.com`. Al agregar un dominio nuevo (`heroku domains:add`), **también** hay que añadirlo aquí o Django devuelve 400. |
| `SECURE_SSL_REDIRECT` | `True` en producción: fuerza HTTP→HTTPS. |
| `FIREBASE_URL` | URL de la Realtime DB de Firebase (suscriptores del boletín). |
| `EMAIL_HOST_USER` | Usuario SMTP (Mailgun) para el aviso de suscripción. |
| `EMAIL_HOST_PASSWORD` | Clave SMTP (Mailgun). |

### Nota crítica: `SECURE_SSL_REDIRECT` + proxy de Heroku

`SECURE_SSL_REDIRECT=True` **solo funciona** porque `settings.py` define:

```python
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
```

Heroku termina el TLS **antes** del dyno y reenvía por HTTP con el header
`X-Forwarded-Proto`. Sin esa línea, Django ve la request como no-segura y
`SECURE_SSL_REDIRECT` genera un **bucle de redirección infinito**
(`ERR_TOO_MANY_REDIRECTS`) que tira el sitio. **No quitar esa línea.**

---

## 4. Pendientes

| Variable | Estado / acción |
|---|---|
| `RECAPTCHA_SECRET_KEY` | **NO seteada. El formulario de boletín está muerto hasta configurarla.** Sacar el *secret* de la consola de Google reCAPTCHA (con `ri.caduinmobiliaria.com` registrado) y correr `heroku config:set RECAPTCHA_SECRET_KEY=… -a caducancun`. |
| `FIREBASE_TOKEN` | Sin setear. Necesario para escribir con auth server-side y así **cerrar las reglas** de la Realtime DB (hoy la escritura se omite si no está). |
| `SENTRY_DSN` | Opcional. Sin él, Sentry queda desactivado. Setear si se quiere reporte de errores. |

---

## 5. Rollback de emergencia

```bash
heroku rollback v968 -a caducancun
```

`v968` es el **último slug Ruby/Sinatra funcional**.

> ⚠️ Válido **solo mientras Heroku conserve ese slug** (Heroku purga releases
> viejos con el tiempo). Verificar con `heroku releases -a caducancun` antes de
> confiar en él. Si ya no existe, el rollback debe hacerse redeployando un
> commit Django previo conocido como bueno.

---

## 6. Staging

**`rebranding-cadu`** es el **espejo de producción** para ensayar cambios:

- Mismo commit que prod, config equivalente.
- Buildpack `heroku/python`, `gunicorn cadu.wsgi`.
- URL: `https://rebranding-cadu-843c4823e4d8.herokuapp.com/`

### Flujo de trabajo

```
cambio (commit)  →  push a staging (rebranding-cadu)  →  verificar  →  push a prod (caducancun)
```

Verificación mínima en staging antes de ir a prod:

```bash
# App arriba y sirviendo
heroku ps -a rebranding-cadu
curl -sIL -o /dev/null -w "%{http_code}\n" https://rebranding-cadu-843c4823e4d8.herokuapp.com/es/   # 200
# HTTP redirige UNA vez a HTTPS (sin bucle)
curl -sIL -o /dev/null -w "code=%{http_code} redirects=%{num_redirects}\n" \
  http://rebranding-cadu-843c4823e4d8.herokuapp.com/es/
```

### Apuntar el remote `heroku` a cada app

```bash
heroku git:remote -a rebranding-cadu   # staging
heroku git:remote -a caducancun        # producción
git remote get-url heroku              # VERIFICAR antes de cada push
```
