#!/usr/bin/env bash
set -euo pipefail

# Output the credentials and config of a service's RDS instance

USAGE="Usage: $(basename "${BASH_SOURCE[0]}") <service_name>"

if [ "${1:-}" == "-h" ]; then
  echo "$USAGE"
  exit
elif [ "$#" -lt 1 ]; then
  echo "$USAGE"
  exit 1
fi

SERVICE="$1"

kubectl -n "$STACK" get secret "$SERVICE-db-config" -o json | jq '.data | map_values(@base64d)'
