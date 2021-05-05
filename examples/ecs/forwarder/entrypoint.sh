#!/usr/bin/env bash
set -euo pipefail

# Bootstrapping for the forwarding agent

if [ "$#" -gt 0 ]; then
  STACK_ID="$(aws opsworks describe-stacks | jq -r '.Stacks[] | select(.Name == "'"$STACK-$ENV-bastion"'") | .StackId')"
  export BASTION_IP="$(aws opsworks describe-instances --stack-id "$STACK_ID" | jq -r '.Instances[] | select(.Hostname == "bastion") | .PublicIp')"
  export SSH_USER="$(aws opsworks describe-my-user-profile | jq -r '.UserProfile.SshUsername')"

  exec "$@"
else
  echo 'Available commands:'
  for file in /"$PWD"/bin/*; do
    $file -h | sed 's/^Usage: /  /'
  done
fi
