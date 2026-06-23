#!/bin/bash
set -e

SCRIPT_DIR=$(dirname "$0")

if [ $# -lt 2 ]; then
    echo "Usage: $0 <cert_name> <ca_name>"
    exit 1
fi

cert_name="$1"
ca_name="$2"

CA_DIR="$SCRIPT_DIR/$ca_name"
PRIVATE_DIR="$CA_DIR/private"
CSR_DIR="$CA_DIR/csr"
CNF_DIR="$CA_DIR/cnf"
CERTS_DIR="$CA_DIR/certs"

ca_key="$PRIVATE_DIR/$ca_name.key"
ca_cert="$CERTS_DIR/$ca_name.pem"

cert_csr="$CSR_DIR/$cert_name.csr"
cert_crt="$CERTS_DIR/$cert_name.crt"

if [ ! -f "$cert_csr" ]; then
    echo "CSR not found: $cert_csr"
    exit 1
fi

echo "Signing certificate with CA..."
openssl_cnf="$CNF_DIR/$cert_name.cnf"

openssl x509 -req -in "$cert_csr" \
    -CA "$ca_cert" -CAkey "$ca_key" -CAcreateserial \
    -out "$cert_crt" -days 825 -sha256 \
    -extfile "$openssl_cnf" -extensions req_ext

clear
echo "Certificate issued: $cert_crt"
