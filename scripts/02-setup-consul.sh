#!/usr/bin/env bash

DIR="$(pwd)/ca"

GOSSIP_ENCRYPTION_KEY="$(consul keygen)"

kubectl create serviceaccount consul-user

kubectl create secret generic consul-certs \
  --from-file="ca.pem=${DIR}/ca.pem" \
  --from-file="consul.pem=${DIR}/consul.pem" \
  --from-file="consul-key.pem=${DIR}/consul-key.pem"

kubectl create secret generic consul-gossip-key \
  --from-literal="key=${GOSSIP_ENCRYPTION_KEY}" \

kubectl apply -f ../consul/statefulset.yaml
kubectl apply -f ../consul/service.yaml
