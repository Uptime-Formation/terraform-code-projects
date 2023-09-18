#!/bin/bash
set -e
panic(){ echo -e "\n$@\n"; exit; }
enter(){ echo; read -p "Type enter to run operation: $@"; }

# Deploys certbot and retrieves cert 
# Run it on green for the last scenario

enter "Provide some variables"

while [[ -z "$FLOATING_IP" ]] ; do
  read -e -p "What is your Floating IP / Load Balancer IP address?: " FLOATING_IP
done
while [[ -z "$DOMAIN" ]] ; do
  read -e -p "What is your application Domain?: " DOMAIN
done

DNS_IP=$(getent ahostsv4 $DOMAIN | grep RAW | awk '{print $1}')
if [[ "$DNS_IP" != "$FLOATING_IP" ]] ; then
  echo "The address for the DNS record ('$DNS_IP') does not match your input ('$FLOATING_IP')."
  read -n 1 -e -p "Are you sure you want to continue? [n/Y] : "
  REPLY=${REPLY:-Y}
  [[ ${REPLY^^} == "N" ]] && echo "Exiting" && exit
fi

enter "Install and configure packages"

apt install -y certbot nginx
mkdir -p  /var/lib/letsencrypt/.well-known/acme-challenge
cat << NGX > /etc/nginx/sites-enabled/default
server {
  listen 80;
  server_name _;
  client_max_body_size 3m;
  location ~/.well-known/acme-challenge{
    root /var/lib/letsencrypt;
  }
  location / {
   return 301 https://$host$request_uri;
  }
}
NGX
service nginx reload

enter "Test the configuration"

echo $(hostname) > /var/lib/letsencrypt/.well-known/acme-challenge/test.txt
curl http://localhost/.well-known/acme-challenge/test.txt
curl http://${FLOATING_IP}/.well-known/acme-challenge/test.txt

enter "Request the certificate"

/usr/bin/letsencrypt certonly --webroot --agree-tos -w /var/lib/letsencrypt/ --register-unsafely-without-email --expand -d $DOMAIN

enter "Convert the certificate"

mkdir -p /etc/ssl/${DOMAIN}
cat /etc/letsencrypt/live/${DOMAIN}/fullchain.pem /etc/letsencrypt/live/${DOMAIN}/privkey.pem | tee /etc/ssl/${DOMAIN}.pem
openssl pkcs12 -export -inkey  /etc/ssl/${DOMAIN}.pem -in  /etc/ssl/${DOMAIN}.pem -out  /etc/ssl/${DOMAIN}.p12

enter "Print the command to execute in your environment"

echo -e "\nPlease copy the following command.\nopenstack secret store --name='certification_tls_cert' -t 'application/octet-stream' -e 'base64' --payload=\"$(base64 < /etc/ssl/${DOMAIN}.p12)\""
