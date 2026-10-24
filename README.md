# Radar Ofertas — Frontend

SPA React + nginx (produção) ou Vite (dev). Backend: **radar-ofertas-backend**.

## Variáveis

| Arquivo | Uso |
|---------|-----|
| `.env.example` | Local + docker compose |
| `.env.dokploy.example` | Copiar para o painel Dokploy |

| Variável | Onde |
|----------|------|
| `API_PROXY_UPSTREAM` | Runtime nginx/Dokploy — `host:3001` interno |
| `VITE_API_BASE_URL` | Build (Dokploy build arg) se API for outro domínio |
| `VITE_DEV_API_PROXY_TARGET` | `npm run dev` ou docker dev |

## Local

```bash
cp .env.example .env
npm install
npm run dev
```

## Docker

```bash
docker compose up -d --build          # :3000 → nginx :80
docker compose --profile dev up -d    # Vite :5173
```

Dokploy: ver [DOKPLOY.md](./DOKPLOY.md).
