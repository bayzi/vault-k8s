#!/usr/bin/env bash

kubectl delete serviceaccount vault-user
kubectl delete -f ../vault/vault-cm.yaml
kubectl delete -f ../vault/vault-svc.yaml
kubectl delete -f ../vault/vault-sts.yaml