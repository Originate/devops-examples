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

PGCFG="$(kubectl -n "$STACK" get secret "$SERVICE-db-config" -o json)"

PGHOST="$(echo "$PGCFG" | jq -r '.data.PGHOST' | base64 -d)"
PGPORT="$(echo "$PGCFG" | jq -r '.data.PGPORT' | base64 -d)"

LOCAL_PORT="${2:-"$PGPORT"}"

port-forward "$PGHOST" "$PGPORT" "$LOCAL_PORT"
