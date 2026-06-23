#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

if [ $# -eq 1 ];then
    ca_name="$1"
else
    read -p "Enter Certificate Authority (CA) name: " ca_name
fi

CA_DIR="$SCRIPT_DIR/$ca_name"
PRIVATE_DIR="$CA_DIR/private"
CSR_DIR="$CA_DIR/csr"
CERTS_DIR="$CA_DIR/certs"

CA_CERT="$CERTS_DIR/$ca_name.pem"

if [ ! -d "$CA_DIR" ]; then
    echo "[$CA_DIR] No directory found"
    exit 1
fi

if [ ! -f "$CA_CERT" ]; then
    echo "[$CA_CERT] No certificate found for $ca_name"
    exit 1
fi

clear
echo "Adding the Root Certificate to Linux..."
sudo cp "$CA_CERT" "/usr/local/share/ca-certificates/$ca_name.crt"
sudo update-ca-certificates
echo "Adding the Root Certificate to Linux [done]"

clear
echo "🎉 Congratulations, your CA certificate is installed."