#!/bin/bash

mkdir -p certs
cd certs

# CA-Zertifikat erstellen
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 \
  -subj "/O=Redis Test/CN=Redis CA" \
  -out ca.crt

# Server-Zertifikat erstellen
openssl genrsa -out redis.key 2048
openssl req -new -key redis.key \
  -subj "/O=Redis Test/CN=localhost" \
  -out redis.csr
openssl x509 -req -in redis.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out redis.crt -days 3650 -sha256

# Optional: Diffie-Hellman-Parameter
openssl dhparam -out redis.dh 2048
