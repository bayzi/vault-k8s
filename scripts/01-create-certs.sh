#!/usr/bin/env bash

DIR="$(pwd)/ca"

rm -rf "${DIR}"
mkdir -p "${DIR}"
cd "${DIR}"

# Generate CA

cfssl gencert -initca ../ca-conf/ca-csr.json | cfssljson -bare ca

# Generate certs

cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=../ca-conf/ca-config.json \
    -profile=default \
    ../ca-conf/consul-csr.json | cfssljson -bare consul