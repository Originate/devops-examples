#!/usr/bin/env bash
set -euo pipefail

# Port forward to a service's RDS instance

USAGE="Usage: $(basename "${BASH_SOURCE[0]}") <service_name> [<local_port>]  (local_port defaults to same port as the RDS instance, typically 5432)"

if [ "${1:-}" == "-h" ]; then
  echo "$USAGE"
  exit
elif [ "$#" -lt 1 ]; then
  echo "$USAGE"
  exit 1
fi

SERVICE="$1"

DB_CFG="$(kubectl -n "$STACK" get secret "$SERVICE-database-config" -o json)"

DB_HOST="$(echo "$DB_CFG" | jq -r '.data.DB_HOST' | base64 -d)"
DB_PORT="$(echo "$DB_CFG" | jq -r '.data.DB_PORT' | base64 -d)"

LOCAL_PORT="${2:-"$DB_PORT"}"

port-forward "$DB_HOST" "$DB_PORT" "$LOCAL_PORT"
