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
API_PROXY_UPSTREAM=nome-interno-do-app-backend:3001
```

- Sem `http://` — só `host:porta`.
- Descubra o hostname na rede Docker do Dokploy (nome do serviço/backend).
- **Não** configure `DATABASE_URL`, `MYSQL_*`, `REDIS_*` neste app.

## Build arguments (opcional)

Só se a API for **outro domínio** (sem proxy `/api` no nginx):

```env
VITE_API_BASE_URL=https://api.seudominio.com
```

No backend, configure `API_CORS_ORIGINS=https://rdofertas.simplapp.com.br`.

## Domain

- Host: `rdofertas.simplapp.com.br`
- Container Port: **80**
- HTTPS: Let's Encrypt

## 502

1. Deploy/build verde e container **Running**.
2. Logs: sem erro de `nginx -t`.
3. `API_PROXY_UPSTREAM` apontando para o backend na mesma rede.
