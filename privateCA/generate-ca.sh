#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

read -p "Enter Certificate Authority (CA) name: " ca_name

CA_DIR="$SCRIPT_DIR/$ca_name"

PRIVATE_DIR="$CA_DIR/private"
CSR_DIR="$CA_DIR/csr"
CERTS_DIR="$CA_DIR/certs"

clear
echo "Setup directories..."
if [ ! -d "$CA_DIR" ];then
	mkdir "$CA_DIR"
fi
if [ ! -d "$PRIVATE_DIR" ];then
	mkdir $PRIVATE_DIR
fi
if [ ! -d "$CSR_DIR" ];then
	mkdir $CSR_DIR
fi
if [ ! -d "$CERTS_DIR" ];then
	mkdir $CERTS_DIR
fi
echo "Setup directories [done]"

ca_key="$PRIVATE_DIR/$ca_name.key"
ca_cert="$CERTS_DIR/$ca_name.pem"

clear
echo "Generating CA key..."
openssl genrsa -des3 -out "$ca_key" 2048
echo "Generating CA key [done]"

clear
echo "Generating CA certificate..."
openssl req -x509 -new -nodes -key "$ca_key" -sha256 -days 3650 -out "$ca_cert"
echo "Generating CA certificate [done]"

clear
echo "🎉 Congratulations, you’re now a CA."
echo "CA key: $ca_key"
echo -e "CA cert: $ca_cert\n"

if [ ! -f "$SCRIPT_DIR/install.sh" ];then
	chmod +x "$SCRIPT_DIR/install.sh"
	$SCRIPT_DIR/install.sh $ca_name
else
	echo "What's next? Your CA need to be trust. So, distribute your certificate"
fi