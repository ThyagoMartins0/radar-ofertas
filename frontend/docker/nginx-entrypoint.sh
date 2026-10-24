#!/bin/sh
set -eu

UPSTREAM="${API_PROXY_UPSTREAM:-host.docker.internal:3001}"
sed "s|API_PROXY_UPSTREAM_PLACEHOLDER|${UPSTREAM}|g" /etc/nginx/conf.d/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
