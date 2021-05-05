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

ssh -4fNv -L "0.0.0.0:$LOCAL_PORT:$DEST_HOST:$DEST_PORT" -o StrictHostKeyChecking=no -E /var/log/ssh.log "$SSH_USER"@"$BASTION_IP"

tail -f /var/log/ssh.log
