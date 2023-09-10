#! /bin/bash

# Copies SSH key, install script and create shortcuts

KEY="id_ecdsa_ovh"
INSTALL_SCRIPT="01-Docker-App.sh"
APP_PATH=$( cd $(dirname $0) && pwd )
set -e

while [[ -z "$BASTION_IP" ]] ||  ! ping -c 1  $BASTION_IP &> /dev/null; do
  echo "Missing or Invalid IP address."
  read -e -p "What is the relay instance IP address?: " BASTION_IP
done

read -e -p "What is the Blue instance IP address?: " BLUE_IP
read -e -p "What is the Green instance IP address?: " GREEN_IP

echo "Copying key."
rsync -e "ssh -vi $HOME/.ssh/$KEY" -av "$HOME/.ssh/$KEY" "ubuntu@$BASTION_IP:~/.ssh" &>/dev/null

echo "Copying install."
rsync -e "ssh -vi $HOME/.ssh/$KEY" -av "$APP_PATH/$INSTALL_SCRIPT" "ubuntu@$BASTION_IP:~" &>/dev/null

echo "Copying shortcuts."
TMP=$(mktemp)
cat <<EOF > $TMP
alias blue="ssh -i '/home/ubuntu/.ssh/$KEY'  'ubuntu@$BLUE_IP'"
alias bluecopy="rsync -e 'ssh -i \$HOME/.ssh/$KEY' -a \$HOME/$INSTALL_SCRIPT  'ubuntu@$BLUE_IP:~/' "
alias green="ssh -i '/home/ubuntu/.ssh/$KEY'  'ubuntu@$GREEN_IP'"
alias greencopy="rsync -e 'ssh -i \$HOME/.ssh/$KEY' -a \$HOME/$INSTALL_SCRIPT  'ubuntu@$GREEN_IP:~/' "
EOF

rsync -e "ssh -vi $HOME/.ssh/$KEY" -av $TMP ubuntu@$BASTION_IP:~/.bash_profile &>/dev/null

rm -f $TMP

cat << EOF
Connect using:

  $ ssh -i "~/.ssh/$KEY" "ubuntu@$BASTION_IP"

Then connect to green or blue using

  $ green
  $ blue

EOF
