#!/usr/bin/env bash

kubectl delete secret consul

kubectl delete -f ../consul/statefulset.yaml  --force --grace-period 0
kubectl delete -f ../consul/service.yaml
kubectl delete secret consul-certs consul-gossip-key
kubectl delete pvc -l app=consul
kubectl delete sa consul-user
