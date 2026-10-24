# Dokploy — frontend (`rdofertas`)

## Build

| Campo | Valor |
|--------|--------|
| Repositório | `radar-ofertas_THYAGO` |
| Build context | `.` (raiz) |
| Dockerfile | `Dockerfile` |
| Container Port (Domain) | **80** |

## Environment (runtime)

Copie de `.env.dokploy.example`:

```env
API_PUBLIC_URL=https://backlmbot.simplapp.com.br
```

O browser chama a API direto. Evita 502 no `/api` do nginx.

- **Não** configure `DATABASE_URL`, `MYSQL_*`, `REDIS_*` neste app.
- No backend, `API_CORS_ORIGINS` já inclui `https://rdofertas.simplapp.com.br`.
- Login ML (noVNC): o link **não** usa `rdofertas:6080`. A API envia `novncUrl` quando `MANAGER_NOVNC_PUBLIC_URL` está definida no backend. Opcional no build: `VITE_NOVNC_PUBLIC_URL` (mesmo host do domínio VNC na porta 6080).

## Build arguments (opcional)

Só se a API for **outro domínio** (sem proxy `/api` no nginx):

```env
VITE_API_BASE_URL=https://api.seudominio.com
```

No backend, configure `API_CORS_ORIGINS=https://rdofertas.simplapp.com.br`.

## Domain

- Host: `rdofertas.simplapp.com.br`
- Path / Internal Path: `/`
- Strip Path: desligado
- Container Port: **80**
- Custom Entrypoint: desligado
- **HTTPS: ligado** (Let's Encrypt)
- Middlewares: vazio

HTTP sem HTTPS no painel ainda redireciona (308) para `https://` no Traefik — deixe o toggle **ligado**.

## 502

O 502 em `GET /` significa que o Traefik não alcança o nginx (container parado ou crash na subida), não um erro de API.

1. **HTTPS ligado** + Container Port **80**.
2. Deploy/build verde e container **Running** (não Restarting).
3. Logs: `nginx` iniciou sem `host not found in upstream`.
4. `API_PROXY_UPSTREAM=https://backlmbot.simplapp.com.br` — sem isso o login em `/api` dá 502.
   Um valor errado não derruba a home — só o `/api` falha.
