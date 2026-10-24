#!/bin/sh
set -eu

for forbidden in DATABASE_URL MYSQL_USER MYSQL_PASSWORD MYSQL_DATABASE MYSQL_HOST MYSQL_PORT MYSQL_ROOT_PASSWORD MYSQL_DOCKER_HOST; do
  eval "value=\${$forbidden:-}"
  if [ -n "$value" ]; then
    echo "[frontend] AVISO: ${forbidden} ignorada neste container (painel não usa banco)." >&2
  fi
done

UPSTREAM="${API_PROXY_UPSTREAM:-host.docker.internal:3001}"
UPSTREAM="${UPSTREAM#http://}"
UPSTREAM="${UPSTREAM#https://}"
UPSTREAM="${UPSTREAM%/}"

CONF="/etc/nginx/conf.d/default.conf"
TEMPLATE="/etc/nginx/templates/default.conf.template"

if [ ! -f "$TEMPLATE" ]; then
  echo "[frontend] ERRO: template nginx ausente: $TEMPLATE" >&2
  exit 1
fi

if [ ! -f /usr/share/nginx/html/index.html ]; then
  echo "[frontend] ERRO: build da SPA ausente (index.html)." >&2
  exit 1
fi

sed "s|__API_UPSTREAM__|${UPSTREAM}|g" "$TEMPLATE" > "$CONF"
echo "[frontend] nginx :80 | /api → http://${UPSTREAM}"

exec nginx -g 'daemon off;'
