# syntax=docker/dockerfile:1
# Build na raiz do repo (Dokploy / docker build .).
# Painel React — sem backend. API via API_PROXY_UPSTREAM no runtime.

FROM node:22-bookworm-slim AS build

WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci --ignore-scripts

COPY frontend/ .

ARG VITE_API_BASE_URL=
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN npm run build

FROM nginx:1.27-alpine AS runtime

RUN apk add --no-cache curl

COPY frontend/docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY frontend/docker/entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -fsS http://127.0.0.1/ >/dev/null || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
