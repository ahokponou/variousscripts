#!/bin/bash
set -e

if [ $# -lt 1 ]; then
    read -p "Enter certificate name (CN): " cert_name
else
    cert_name="$1"
fi

if [ $# -lt 2 ]; then
    read -p "Enter CA name: " ca_name
else
    ca_name="$2"
fi

CA_DIR="/opt/$ca_name"

if [ ! -d "$CA_DIR" ];then
  echo "$ca_name doesn't exist. Exiting..."
  exit 1
fi

read -p "Enter comma-separated SANs (e.g. DNS:example.com,DNS:www.example.com,IP:127.0.0.1): " san_input

PRIVATE_DIR="$CA_DIR/private"
CSR_DIR="$CA_DIR/csr"
CNF_DIR="$CA_DIR/cnf"

cert_key="$PRIVATE_DIR/$cert_name.key"
cert_csr="$CSR_DIR/$cert_name.csr"
openssl_cnf="$CNF_DIR/$cert_name.cnf"

cat > "$openssl_cnf" <<EOF
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = req_ext

[ dn ]
CN = $cert_name

[ req_ext ]
subjectAltName = ${san_input}
EOF

clear
echo "Generating key and CSR with SAN..."
if ! openssl req -new -nodes -keyout "$cert_key" -out "$cert_csr" -config "$openssl_cnf";then
    echo "Cannot generate "
    exit 1
fi

clear
echo "CSR: $cert_csr"
echo "Key: $cert_key"
echo "SANs: $san_input"
