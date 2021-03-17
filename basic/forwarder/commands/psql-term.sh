#!/usr/bin/env bash
set -euo pipefail

# Connect to a service's RDS instance using psql

USAGE="Usage: $(basename "${BASH_SOURCE[0]}") <service_name>"

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
PGDATABASE="$(echo "$PGCFG" | jq -r '.data.PGDATABASE' | base64 -d)"
PGUSER="$(echo "$PGCFG" | jq -r '.data.PGUSER' | base64 -d)"
PGPASSWORD="$(echo "$PGCFG" | jq -r '.data.PGPASSWORD' | base64 -d)"

ssh -4fNv -L "0.0.0.0:5432:$PGHOST:$PGPORT" -o StrictHostKeyChecking=no -E /var/log/ssh.log ssh-user@localhost -p 65535

PGPASSWORD="$PGPASSWORD" psql --host="localhost" --port="5432" --username="$PGUSER" --dbname="$PGDATABASE"
