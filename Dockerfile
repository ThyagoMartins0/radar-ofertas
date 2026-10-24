# syntax=docker/dockerfile:1
# Dokploy / docker build . — painel React (nginx :80). Sem entrypoint customizado.

FROM node:22-bookworm-slim AS build

WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci --ignore-scripts

COPY frontend/ .

ARG VITE_API_BASE_URL=
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

RUN npm run build

FROM nginx:1.27-alpine AS runtime

# Substituído pelo entrypoint oficial do nginx (envsubst em /etc/nginx/templates/*.template)
ENV API_PROXY_UPSTREAM=host.docker.internal:3001

COPY frontend/docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
