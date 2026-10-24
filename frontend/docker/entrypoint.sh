#!/bin/sh
set -eu

for forbidden in DATABASE_URL MYSQL_USER MYSQL_PASSWORD MYSQL_DATABASE MYSQL_HOST MYSQL_PORT MYSQL_ROOT_PASSWORD MYSQL_DOCKER_HOST; do
  eval "value=\${$forbidden:-}"
  if [ -n "$value" ]; then
    echo "[frontend] ERRO: variável de banco ${forbidden} no container do painel." >&2
    echo "[frontend] O frontend NÃO acessa MySQL. Remova do Dokploy/compose e configure só API_PROXY_UPSTREAM." >&2
    exit 1
  fi
done

UPSTREAM="${API_PROXY_UPSTREAM:-host.docker.internal:3001}"
CONF="/etc/nginx/conf.d/default.conf"
TEMPLATE="/etc/nginx/templates/default.conf.template"

if [ ! -f "$TEMPLATE" ]; then
  echo "nginx template ausente: $TEMPLATE" >&2
  exit 1
fi

sed "s|__API_UPSTREAM__|${UPSTREAM}|g" "$TEMPLATE" > "$CONF"
echo "[frontend] proxy /api → http://${UPSTREAM} (sem conexão direta ao banco)"

exec nginx -g 'daemon off;'
