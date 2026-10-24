# Radar Ofertas — Frontend

SPA React (Vite) do painel. **Backend/API** no repositório `radar-ofertas-backend`.

## Configuração

```bash
cp .env.example .env
```

| Variável | Uso |
|----------|-----|
| `VITE_DEV_API_PROXY_TARGET` | Dev: destino do proxy `/api` (padrão `http://127.0.0.1:3001`) |
| `VITE_API_BASE_URL` | Produção: URL absoluta da API (se não usar proxy nginx) |
| `API_PROXY_UPSTREAM` | Docker prod: host:porta do backend para nginx (padrão `host.docker.internal:3001`) |

No **backend**, configure `API_CORS_ORIGINS` com a URL do painel (ex.: `http://localhost:5173`).

## Desenvolvimento local

```bash
# Terminal 1 — backend (outro repo)
cd ../radar-ofertas-backend
cp .env.example .env
npm run api

# Terminal 2 — frontend
npm install
npm run dev
```

Painel: **http://localhost:5173** — login `API_ADMIN_USERNAME` / `API_ADMIN_PASSWORD` do backend.

## Docker

Com o backend rodando e API em **:3001** no host:

```bash
docker compose --profile dev up -d frontend-dev    # HMR :5173
docker compose --profile prod up -d --build frontend # nginx :3000, proxy /api
```

## Testes

```bash
npm test
npm run test:e2e
```
