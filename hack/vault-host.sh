#!/bin/sh

set -e
#set -x

THIS_DIR="$(dirname "$(realpath "$0")")"

VAULT_ENV_DIR="${THIS_DIR}/../config/bases/vault/.genenv"

mkdir -p "${VAULT_ENV_DIR}"

NAMESPACE=${NAMESPACE:-spi-vault}
POD_NAME=${POD_NAME:-vault-0}

API_RESOURCES=$( kubectl api-resources )
if echo ${API_RESOURCES} | grep routes > /dev/null; then
  VAULT_HOST=$( kubectl get route -n ${NAMESPACE} vault -o json | jq -r .spec.host )
elif echo ${API_RESOURCES} | grep ingresses > /dev/null; then
  VAULT_HOST=$( kubectl get ingress -n ${NAMESPACE} vault -o json | jq -r '.spec.rules[0].host' )
fi

if [ ! -z ${VAULT_HOST} ]; then
  echo "VAULTHOST=https://${VAULT_HOST}" > ${VAULT_ENV_DIR}/vault.env
  echo "Generated at: $(realpath ${VAULT_ENV_DIR})"
fi
