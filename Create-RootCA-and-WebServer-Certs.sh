# install ca package
if ! [ `command -y update-ca-certificates` ]; then sudo apt install -y ca-certificates; fi

# PARAMETERS
CA_NAME='MyLab_RootCA'
CA_SUBJECT='/CN=My Lab Root CA/C=US/ST=Arizona/L=Cochise/O=Progress/OU=Sales'


################ GENERATE ROOT CA #####################

if ! test -f /usr/local/share/ca-certificate/$CA_NAME.crt; then

  echo "Creating and installing new Root CA Certificate named ${CA_NAME}.crt"

  # generate aes encrypted private key
  openssl genrsa -aes256 -out $CA_NAME.key 4096

  # generate root CA
  openssl req -x509 -new -nodes -key $CA_NAME.key -sha256 -days 1826 -out $CA_NAME.crt -subj "$CA_SUBJECT" 

  # copy and initialize root ca
  sudo cp $CA_NAME.crt /usr/local/share/ca-certificates/
  sudo update-ca-certificates

else

  echo "Using existing root CA named ${CA_NAME}.crt"

fi

################# GENERATE WEB SERVER CERTIFICATE ########################

#### node1 ####
MY_NAME='node1'
MY_DOMAIN='local'
MY_IP='10.0.0.7'
MY_SUBJECT="/CN=$MY_NAME/C=US/ST=Arizona/L=Cochise/O=Progress/OU=Lab"
cat > $MY_NAME.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $MY_NAME
DNS.2 = $MY_NAME.$MY_DOMAIN
IP.1 = $MY_IP
EOF
#
echo "Creating new web server certificate named ${MY_NAME}.crt"
openssl req -new -nodes -out $MY_NAME.csr -newkey rsa:4096 -keyout $MY_NAME.key -subj "$MY_SUBJECT"
openssl x509 -req -in $MY_NAME.csr -CA $CA_NAME.crt -CAkey $CA_NAME.key -CAcreateserial -out $MY_NAME.crt -days 730 -sha256 -extfile $MY_NAME.ext
rm $MY_NAME.ext

#### node2 ####
MY_NAME='node2'
MY_DOMAIN='local'
MY_IP='10.0.0.8'
MY_SUBJECT="/CN=$MY_NAME/C=US/ST=Arizona/L=Cochise/O=Progress/OU=Lab"
cat > $MY_NAME.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $MY_NAME
DNS.2 = $MY_NAME.$MY_DOMAIN
IP.1 = $MY_IP
EOF
#
echo "Creating new web server certificate named ${MY_NAME}.crt"
openssl req -new -nodes -out $MY_NAME.csr -newkey rsa:4096 -keyout $MY_NAME.key -subj "$MY_SUBJECT"
openssl x509 -req -in $MY_NAME.csr -CA $CA_NAME.crt -CAkey $CA_NAME.key -CAcreateserial -out $MY_NAME.crt -days 730 -sha256 -extfile $MY_NAME.ext
rm $MY_NAME.ext

#### node3 ####
MY_NAME='node3'
MY_DOMAIN='local'
MY_IP='10.0.0.9'
MY_SUBJECT="/CN=$MY_NAME/C=US/ST=Arizona/L=Cochise/O=Progress/OU=Lab"
cat > $MY_NAME.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $MY_NAME
DNS.2 = $MY_NAME.$MY_DOMAIN
IP.1 = $MY_IP
EOF
#
MY_SUBJECT='/CN=node3/C=US/ST=Arizona/L=Cochise/O=Progress/OU=Sales'
echo "Creating new web server certificate named ${MY_NAME}.crt"
openssl req -new -nodes -out $MY_NAME.csr -newkey rsa:4096 -keyout $MY_NAME.key -subj "$MY_SUBJECT"
openssl x509 -req -in $MY_NAME.csr -CA $CA_NAME.crt -CAkey $CA_NAME.key -CAcreateserial -out $MY_NAME.crt -days 730 -sha256 -extfile $MY_NAME.ext
rm $MY_NAME.ext

#### node4 ####
MY_NAME='node4'
MY_DOMAIN='local'
MY_IP='10.0.0.10'
MY_SUBJECT="/CN=$MY_NAME/C=US/ST=Arizona/L=Cochise/O=Progress/OU=Lab"
cat > $MY_NAME.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $MY_NAME
DNS.2 = $MY_NAME.$MY_DOMAIN
IP.1 = $MY_IP
EOF
#
echo "Creating new web server certificate named ${MY_NAME}.crt"
openssl req -new -nodes -out $MY_NAME.csr -newkey rsa:4096 -keyout $MY_NAME.key -subj "$MY_SUBJECT"
openssl x509 -req -in $MY_NAME.csr -CA $CA_NAME.crt -CAkey $CA_NAME.key -CAcreateserial -out $MY_NAME.crt -days 730 -sha256 -extfile $MY_NAME.ext
rm $MY_NAME.ext



ls -l


