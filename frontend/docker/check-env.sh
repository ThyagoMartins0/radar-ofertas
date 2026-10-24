#!/bin/sh
set -eu

for forbidden in DATABASE_URL MYSQL_USER MYSQL_PASSWORD; do
  eval "value=\${$forbidden:-}"
  if [ -n "$value" ]; then
    echo "[frontend-dev] AVISO: ${forbidden} definida — ignorada (banco só no backend)." >&2
  fi
done

exec "$@"
