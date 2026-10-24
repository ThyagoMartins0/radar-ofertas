# syntax=docker/dockerfile:1
# Dokploy: Build context = raiz do repo | Dockerfile = este arquivo | Container Port = 80
#
# Runtime (Environment no Dokploy):
#   API_PROXY_UPSTREAM=hostname-interno-da-api:3001
# Build args (opcional):
#   VITE_API_BASE_URL=https://api.seudominio.com

FROM node:22-bookworm-slim AS build

WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci --ignore-scripts

COPY frontend/ .

ARG VITE_API_BASE_URL=
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN npm run build

FROM nginx:1.27-alpine AS runtime

LABEL org.opencontainers.image.title="radar-ofertas-frontend"
LABEL org.opencontainers.image.description="SPA React + nginx :80, proxy /api"

# Entrypoint oficial do nginx: envsubst em /etc/nginx/templates/*.template
ENV API_PROXY_UPSTREAM=host.docker.internal:3001
ENV NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/conf.d

COPY frontend/docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
