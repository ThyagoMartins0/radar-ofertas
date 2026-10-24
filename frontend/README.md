# Radar Ofertas — Frontend

SPA React (Vite). **Não** inclui banco nem workers — só UI + proxy HTTP para o **radar-ofertas-backend**.

## Variáveis (`cp .env.example .env`)

| Variável | Quando |
|----------|--------|
| `VITE_DEV_API_PROXY_TARGET` | `npm run dev` ou Docker dev — destino do proxy `/api` |
| `VITE_API_BASE_URL` | Build com API em outro domínio (sem proxy nginx) |
| `API_PROXY_UPSTREAM` | Docker prod — `host:porta` da API (ex. `host.docker.internal:3001` ou `api:3001`) |

No backend: `API_CORS_ORIGINS` com a URL do painel, se usar `VITE_API_BASE_URL` direto.

## Local (sem Docker)

```bash
npm install
npm run dev   # http://localhost:5173
```

Backend em outro terminal: `npm run api` no repo backend.

## Docker

**Produção** (nginx + SPA, proxy `/api`):

```bash
docker compose up -d --build
# http://localhost:3000
```

**Desenvolvimento** (Vite HMR):

```bash
docker compose --profile dev up -d --build
# http://localhost:5173
```

Scripts npm: `npm run docker:up`, `docker:dev`, `docker:down`, `docker:logs`.

### API na rede Docker do backend

```bash
cp docker-compose.backend-network.yml.example docker-compose.override.yml
# API_PROXY_UPSTREAM=api:3001
docker compose up -d --build
```

### Dokploy

- **Build context:** pasta `frontend/` (ou raiz se o repo for só o front).
- **Dockerfile:** `docker/Dockerfile.prod`
- **Porta:** `80` → mapear para domínio do painel.
- **Env:** `API_PROXY_UPSTREAM` = host interno da API (não use `DATABASE_URL` aqui).

## Testes

```bash
npm test
npm run test:e2e
```
