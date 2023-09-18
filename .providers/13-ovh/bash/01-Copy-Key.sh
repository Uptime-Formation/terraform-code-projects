#! /bin/bash

# Copies SSH key

KEY=id_ecdsa_ovh
set -e

while [[ -z "$BASTION_IP" ]] ||  ! ping -c 1  $BASTION_IP &> /dev/null; do
  echo "Missing or Invalid IP address."
  read -e -p "What is the relay instance IP address?: " BASTION_IP
done

echo "Copying key."
rsync -e "ssh -vi $HOME/.ssh/$KEY" -av /home/alban/.ssh/$KEY ubuntu@$BASTION_IP:~/.ssh
