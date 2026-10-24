#!/bin/sh
# Dev container — falha cedo se alguém colou variáveis de banco no deploy do frontend.
set -eu

for forbidden in DATABASE_URL MYSQL_USER MYSQL_PASSWORD; do
  eval "value=\${$forbidden:-}"
  if [ -n "$value" ]; then
    echo "[frontend-dev] ERRO: ${forbidden} definida — banco é só no backend." >&2
    exit 1
  fi
done

exec "$@"
