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

DB_CFG="$(kubectl -n "$STACK" get secret "$SERVICE-database-config" -o json)"

DB_HOST="$(echo "$DB_CFG" | jq -r '.data.DB_HOST' | base64 -d)"
DB_PORT="$(echo "$DB_CFG" | jq -r '.data.DB_PORT' | base64 -d)"
DB_NAME="$(echo "$DB_CFG" | jq -r '.data.DB_NAME' | base64 -d)"
DB_USERNAME="$(echo "$DB_CFG" | jq -r '.data.DB_USERNAME' | base64 -d)"
DB_PASSWORD="$(echo "$DB_CFG" | jq -r '.data.DB_PASSWORD' | base64 -d)"

ssh -4fNv -L "0.0.0.0:5432:$DB_HOST:$DB_PORT" -o StrictHostKeyChecking=no -E /var/log/ssh.log ssh-user@localhost -p 62622

PGPASSWORD="$DB_PASSWORD" psql --host="localhost" --port="5432" --username="$DB_USERNAME" --dbname="$DB_NAME"
