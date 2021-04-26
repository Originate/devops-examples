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

PGCFG="$(pg-credentials "$SERVICE")"

PGHOST="$(echo "$PGCFG" | jq -r '.PGHOST')"
PGPORT="$(echo "$PGCFG" | jq -r '.PGPORT')"
PGDATABASE="$(echo "$PGCFG" | jq -r '.PGDATABASE')"
PGUSER="$(echo "$PGCFG" | jq -r '.PGUSER')"
PGPASSWORD="$(echo "$PGCFG" | jq -r '.PGPASSWORD')"

ssh -4fNv -L "0.0.0.0:5432:$PGHOST:$PGPORT" -o StrictHostKeyChecking=no -E /var/log/ssh.log ssh-user@localhost -p 65535

PGPASSWORD="$PGPASSWORD" psql --host="localhost" --port="5432" --username="$PGUSER" --dbname="$PGDATABASE"
