#!/bin/sh
set -eu

UPSTREAM="${API_PROXY_UPSTREAM:-host.docker.internal:3001}"
CONF="/etc/nginx/conf.d/default.conf"
TEMPLATE="/etc/nginx/templates/default.conf.template"

if [ ! -f "$TEMPLATE" ]; then
  echo "nginx template ausente: $TEMPLATE" >&2
  exit 1
fi

sed "s|__API_UPSTREAM__|${UPSTREAM}|g" "$TEMPLATE" > "$CONF"
echo "[frontend] proxy /api → http://${UPSTREAM}"

exec nginx -g 'daemon off;'
