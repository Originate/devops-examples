#!/usr/bin/env bash
set -euo pipefail

# Bootstrapping for the forwarding agent

if [ "$#" -gt 0 ]; then
  POD="$(kubectl -n bastion get pod -l "app=bastion" -o jsonpath="{.items[0].metadata.name}")"
  SSH_PORT="$(kubectl -n bastion get pod "$POD" -o jsonpath="{.spec.containers[0].ports[0].containerPort}")"

  kubectl -n bastion port-forward "$POD" 65535:"$SSH_PORT" &> /var/log/bastion.log &
  for i in {1..60}; do
    if nc -z localhost 65535; then
      break
    elif [ "$i" -ge 60 ]; then
      echo "Timed out waiting for port forward to bastion host"
      exit 1
    else
      sleep 1
    fi
  done

  exec "$@"
else
  echo 'Available commands:'
  for file in /"$PWD"/bin/*; do
    $file -h | sed 's/^Usage: /  /'
  done
fi
