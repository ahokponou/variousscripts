#!/bin/bash
set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <cert_name> <ca_name>"
    exit 1
fi

cert_name="$1"
ca_name="$2"

CA_DIR="/opt/$ca_name"
PRIVATE_DIR="$CA_DIR/private"
CSR_DIR="$CA_DIR/csr"
CNF_DIR="$CA_DIR/cnf"
CERTS_DIR="$CA_DIR/certs"

if [ ! -d "$CA_DIR" ];then
  echo "$ca_name doesn't exist. Exiting..."
  exit 1
fi

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
ca_passphrase="$PRIVATE_DIR/passphrase.txt"

if ! openssl x509 -req -in "$cert_csr" \
    -CA "$ca_cert" -CAkey "$ca_key" -CAcreateserial \
    -passin file:"$ca_passphrase" \
    -out "$cert_crt" -days 825 -sha256 \
    -extfile "$openssl_cnf" -extensions req_ext;then
        echo "Cannot sign certificate. Exiting..."
        exit 1
fi

clear
echo "Certificate sucessfully issued"
echo "Cert: $cert_crt"
echo "Key: $PRIVATE_DIR/$cert_name.key"
