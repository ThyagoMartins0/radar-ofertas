# Deploy no Dokploy — só frontend

Este repositório **não** roda collector, worker nem Prisma.

| Configurar | Não configurar |
|------------|----------------|
| `API_PROXY_UPSTREAM` (ex. `api:3001` ou host interno da API) | `DATABASE_URL`, `MYSQL_*` |
| Dockerfile: `docker/Dockerfile.prod` | Imagem do backend |
| Porta `80` | Porta `3001` da API aqui |

Logs com `/app/backend/` ou `prisma.setting` = app **backend** errado no mesmo projeto. Crie outro serviço com o repo `radar-ofertas-backend`.
