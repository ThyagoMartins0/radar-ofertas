# Deploy no Dokploy — só frontend

Este repositório **não** roda collector, worker nem Prisma.

| Configurar | Não configurar |
|------------|----------------|
| `API_PROXY_UPSTREAM` (ex. `api:3001` ou host interno da API) | `DATABASE_URL`, `MYSQL_*` |
| **Build context:** raiz do repo | Pasta só `frontend/` sem ajuste |
| **Dockerfile:** `Dockerfile` (raiz) ou `frontend/docker/Dockerfile.prod` | Imagem do backend |
| Porta container `80` | `DATABASE_URL`, `MYSQL_*` |
| Env: `API_PROXY_UPSTREAM=api:3001` (host interno da API) | |

Logs com `/app/backend/` ou `prisma.setting` = app **backend** errado no mesmo projeto. Crie outro serviço com o repo `radar-ofertas-backend`.

## 502 Bad Gateway

1. **Container Port** = `80` (nginx).
2. Logs do container: deve aparecer `[frontend] nginx :80 | ...`. Se o container reinicia, leia a última linha de erro.
3. Variáveis `MYSQL_*` / `DATABASE_URL` não derrubam mais o container (só aviso).
4. Defina `API_PROXY_UPSTREAM` para a API interna (ex. `nome-servico-backend:3001`), não a URL pública HTTPS.
5. Redeploy após push (entrypoint/script atualizado).
