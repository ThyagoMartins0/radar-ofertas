# Deploy no Dokploy — só frontend

Este repositório **não** roda collector, worker nem Prisma.

| Configurar | Não configurar |
|------------|----------------|
| `API_PROXY_UPSTREAM` (ex. `api:3001` ou host interno da API) | `DATABASE_URL`, `MYSQL_*` |
| **Build context:** raiz do repo | Pasta só `frontend/` sem ajuste |
| **Dockerfile:** `Dockerfile` (raiz) ou `frontend/docker/Dockerfile.prod` | Imagem do backend |
| Porta container `80` | `DATABASE_URL`, `MYSQL_*` |
| Env runtime: `API_PROXY_UPSTREAM=nome-servico-api:3001` (sem `http://`) | |

Logs com `/app/backend/` ou `prisma.setting` = app **backend** errado no mesmo projeto. Crie outro serviço com o repo `radar-ofertas-backend`.

## 502 Bad Gateway

1. **Container Port** = `80` (nginx).
2. Logs do container: deve aparecer `[frontend] nginx :80 | ...`. Se o container reinicia, leia a última linha de erro.
3. **Logs:** após subir, rode `nginx -t` no container — config inválida = 502. Template usa `${API_PROXY_UPSTREAM}` (entrypoint oficial do nginx).
4. `API_PROXY_UPSTREAM` = host **interno** Docker do backend (`servico:3001`), não URL HTTPS pública.
5. Mesma rede Docker: no Dokploy, associe frontend e backend à mesma network ou use o hostname interno do app API.
6. Redeploy após cada push.
