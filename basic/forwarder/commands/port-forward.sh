#!/usr/bin/env bash
set -euo pipefail

# Port forward a generic host and port

USAGE="Usage: $(basename "${BASH_SOURCE[0]}") <dest_host> <dest_port> [<local_port>]  (local_port defaults to dest_port)"

if [ "${1:-}" == "-h" ]; then
  echo "$USAGE"
  exit
elif [ "$#" -lt 2 ]; then
  echo "$USAGE"
  exit 1
fi

DEST_HOST="$1"
DEST_PORT="$2"
LOCAL_PORT="${3:-"$DEST_PORT"}"

if [ $LOCAL_PORT -eq 65535 ]; then
  echo "Port 65535 is reserved for connecting to the bastion host"
  exit 2
fi

ssh -4fNv -L "0.0.0.0:$LOCAL_PORT:$DEST_HOST:$DEST_PORT" -o StrictHostKeyChecking=no -E /var/log/ssh.log ssh-user@localhost -p 65535

tail -f /var/log/ssh.log
