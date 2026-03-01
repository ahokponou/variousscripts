#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

read -p "Enter Certificate Authority (CA) name: " ca_name

CA_DIR="/opt/$ca_name"

if [ -d "$CA_DIR" ];then
    echo "$ca_name already exist."
    echo "Certificate: $CA_DIR/certs/$ca_name.pem"
    exit 0
fi

PRIVATE_DIR="$CA_DIR/private"
CSR_DIR="$CA_DIR/csr"
CERTS_DIR="$CA_DIR/certs"
CNF_DIR="$CA_DIR/cnf"

echo "Setup directories..."
if ! mkdir "$CA_DIR";then
    echo "Cannot create directory '$CA_DIR'"
    exit 1
fi
if ! mkdir "$PRIVATE_DIR" "$CSR_DIR" "$CERTS_DIR" "$CNF_DIR";then
    echo "Cannot create directories:"
    echo "- $PRIVATE_DIR"
    echo "- $CSR_DIR"
    echo "- $CERTS_DIR"
    echo "- $CNF_DIR"
    exit 1
fi
echo "Setup directories [done]"

ca_key="$PRIVATE_DIR/$ca_name.key"
ca_cert="$CERTS_DIR/$ca_name.pem"
ca_passphrase="$PRIVATE_DIR/passphrase.txt"

read -sp "Enter passphrase for CA key: " passphrase
echo
read -sp "Confirm passphrase: " passphrase_confirm
echo

if [ "$passphrase" != "$passphrase_confirm" ];then
    echo "Passphrases do not match."
    rm -rf "$CA_DIR"
    exit 1
fi

echo "$passphrase" > "$ca_passphrase"
chmod 400 "$ca_passphrase"
unset passphrase
unset passphrase_confirm

clear
echo "Generating CA key..."
if ! openssl genrsa -des3 -passout file:"$ca_passphrase" -out "$ca_key" 4096;then
    echo "Generating CA key '$ca_key' [failed]"
    rm -rf "$CA_DIR"
    exit 1
fi
echo "Generating CA key [done]"

clear
echo "Generating CA certificate..."
if ! openssl req -x509 -new -nodes -key "$ca_key" -passin file:"$ca_passphrase" -sha256 -days 3650 -out "$ca_cert";then
    echo "Generating CA certificate '$ca_cert' [failed]"
    rm -rf "$CA_DIR"
    exit 1
fi
echo "Generating CA certificate [done]"

clear
echo "🎉 Congratulations, you’re now a CA."
echo "CA key:        $ca_key"
echo "CA cert:       $ca_cert"
echo "CA passphrase: $ca_passphrase"

echo "What's next? Your CA need to be trust. So, distribute your certificate"
exit 0
