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

SSM_PARAMETER_PATH="/$STACK/$ENV/$SERVICE/rds"

aws ssm get-parameters-by-path --path "$SSM_PARAMETER_PATH" --with-decryption | jq -r '[.Parameters[] | {key: .Name | ltrimstr("'"$SSM_PARAMETER_PATH/"'") | ascii_upcase, value: .Value}] | from_entries'
