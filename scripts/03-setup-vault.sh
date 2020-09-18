#!/usr/bin/env bash

SUBSCRIPTION_ID=""
RG=""

VAULT_NAME="vault-$(date +%s | shasum | base64 | head -c 8 ; echo)"
KEY_NAME="generated-key"

VAULT_SP=$(az ad sp create-for-rbac -n ${VAULT_NAME}-sp --role "Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RG}")
VAULT_SP_ID=$(echo $VAULT_SP | jq -r .appId)
VAULT_SP_PASSWORD=$(echo $VAULT_SP | jq -r .password)
VAULT_SP_TENANT=$(echo $VAULT_SP | jq -r .tenant)

az keyvault create --resource-group $RG --name $VAULT_NAME
az keyvault set-policy --name $VAULT_NAME \
--spn $VAULT_SP_ID \
--resource-group $RG \
--key-permissions backup create decrypt delete encrypt get list purge recover restore sign unwrapKey update verify wrapKey

az keyvault key create --name $KEY_NAME --vault-name $VAULT_NAME\
 --kty "RSA" --size 2048 \
 --ops decrypt encrypt sign unwrapKey verify wrapKey

cat >> ../vault/vault-cm.yaml << EOF

    seal "azurekeyvault" {
      client_id      = "${VAULT_SP_ID}"
      client_secret  = "${VAULT_SP_PASSWORD}"
      tenant_id      = "${VAULT_SP_TENANT}"
      vault_name     = "${VAULT_NAME}"
      key_name       = "${KEY_NAME}"
    }
EOF

kubectl create serviceaccount vault-user
kubectl apply -f ../vault/vault-cm.yaml
kubectl apply -f ../vault/vault-svc.yaml
kubectl apply -f ../vault/vault-sts.yaml