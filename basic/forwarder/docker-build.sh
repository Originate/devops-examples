#!/usr/bin/env bash
set -euo pipefail

# Optional utility for running the docker build command, prompting for the
# required build args

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

prompt() {
  local description="$1"
  local var="$2"
  local default="$3"
  local secret="${4:-}"

  while :; do
    local input
    if [ "$secret" == "secret" ]; then
      read -s -r -p "$description [${default:+"****************${default: -4}"}]: " input
      echo
    else
      read -r -p "$description [$default]: " input
    fi
    input="${input:-$default}"

    if [ -z "$input" ]; then
      echo "$description cannot be empty"
    else
      break
    fi
  done
  export "$var"="$input"
}

get_environment_tfvar() {
  local var="$1"
  { grep "^$var *=" "$DIR/../terraform/environment/terraform.tfvars" || :; } | cut -d= -f2 | tr -d ' "'
}

get_aws_profile_value() {
  local var="$1"
  aws configure get "$var" --profile "$STACK" 2> /dev/null || :;
}

prompt "Stack Name" STACK "$(get_environment_tfvar stack)"
prompt "Environment Name" ENV "dev"
prompt "Docker Image Name" IMAGE "${STACK::1}f-$ENV"
prompt "AWS Access Key ID" AWS_ACCESS_KEY_ID "$(get_aws_profile_value aws_access_key_id)" secret
prompt "AWS Secret Access Key" AWS_SECRET_ACCESS_KEY "$(get_aws_profile_value aws_secret_access_key)" secret
prompt "AWS Region" AWS_DEFAULT_REGION "$(get_environment_tfvar region)"

docker build \
  --build-arg STACK \
  --build-arg ENV \
  --build-arg AWS_ACCESS_KEY_ID \
  --build-arg AWS_SECRET_ACCESS_KEY \
  --build-arg AWS_DEFAULT_REGION \
  --build-arg CACHE_BUST="$(date +%s)" \
  -t "$IMAGE" \
  .
