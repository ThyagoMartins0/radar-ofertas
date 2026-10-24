# syntax=docker/dockerfile:1
# Dokploy: context = raiz | este Dockerfile | Container Port = 80
#
# Runtime: API_PROXY_UPSTREAM=https://backlmbot.simplapp.com.br
#   ou hostname-interno:3001 na mesma rede Docker

FROM node:22-bookworm-slim AS build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

COPY . .

ARG VITE_API_BASE_URL=
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
ARG VITE_NOVNC_PUBLIC_URL=
ENV VITE_NOVNC_PUBLIC_URL=${VITE_NOVNC_PUBLIC_URL}

RUN npm run build

FROM nginx:1.27-alpine AS runtime

LABEL org.opencontainers.image.title="radar-ofertas-frontend"

ENV API_PROXY_UPSTREAM=host.docker.internal:3001
ENV API_PROXY_SCHEME=http
ENV API_PROXY_HOST=host.docker.internal
ENV API_PUBLIC_URL=https://backlmbot.simplapp.com.br
ENV NGINX_ENVSUBST_TEMPLATE_SUFFIX=.template
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/conf.d
ENV NGINX_ENVSUBST_FILTER=^API_PROXY_

COPY docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /usr/share/nginx/html

# .envsh é sourced pelo entrypoint oficial (export vale para o envsubst) — só se for executável.
RUN printf '%s\n' \
  '#!/bin/sh' \
  'raw="${API_PROXY_UPSTREAM:-host.docker.internal:3001}"' \
  'scheme=http' \
  'case "$raw" in' \
  '  https://*) scheme=https; raw="${raw#https://}" ;;' \
  '  http://*) scheme=http; raw="${raw#http://}" ;;' \
  'esac' \
  'raw="${raw%/}"' \
  '[ -n "$raw" ] || raw="host.docker.internal:3001"' \
  'hostport="${raw%%/*}"' \
  'hostonly="${hostport%%:*}"' \
  'export API_PROXY_SCHEME="$scheme"' \
  'export API_PROXY_UPSTREAM="$hostport"' \
  'export API_PROXY_HOST="$hostonly"' \
  'url="${API_PUBLIC_URL:-https://backlmbot.simplapp.com.br}"' \
  'url="${url%/}"' \
  'url=$(printf "%s" "$url" | tr -cd "A-Za-z0-9._/:?-")' \
  'printf "window.__API_BASE_URL__=\"%s\";\\n" "$url" > /usr/share/nginx/html/config.js' \
  'vnc="${NOVNC_PUBLIC_URL:-${VITE_NOVNC_PUBLIC_URL:-https://vnc-backlmbot.simplapp.com.br}}"' \
  'vnc="${vnc%/}"' \
  'vnc=$(printf "%s" "$vnc" | tr -cd "A-Za-z0-9._/:?=&-")' \
  'printf "window.__NOVNC_PUBLIC_URL__=\"%s\";\\n" "$vnc" >> /usr/share/nginx/html/config.js' \
  > /docker-entrypoint.d/18-normalize-upstream.envsh \
  && chmod +x /docker-entrypoint.d/18-normalize-upstream.envsh

EXPOSE 80

HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/ >/dev/null || exit 1
