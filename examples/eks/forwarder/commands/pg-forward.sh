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

PGCFG="$(pg-credentials "$SERVICE")"

PGHOST="$(echo "$PGCFG" | jq -r '.PGHOST')"
PGPORT="$(echo "$PGCFG" | jq -r '.PGPORT')"

LOCAL_PORT="${2:-"$PGPORT"}"

port-forward "$PGHOST" "$PGPORT" "$LOCAL_PORT"
