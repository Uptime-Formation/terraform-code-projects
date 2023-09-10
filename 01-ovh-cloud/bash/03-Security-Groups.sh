# /bin/bash
panic(){ echo -e "\n$@\n"; exit; }
enter(){ echo; read -p "Type enter to run operation: $@"; }

SG_NAME=sg_cert_shell

[[ -z "$OS_USERNAME" ]] && panic "Please source the OpenStack RC file. Please visit: \nhttps://help.ovhcloud.com/csm/en-public-cloud-compute-set-openstack-environment-variables?id=kb_article_view&sysparm_article=KB0050920"

enter "Create the Security Group "

openstack security group create $SG_NAME --description "My first Security Group"

enter "Create a Security Group rule "

openstack security group rule create --ingress \
  --protocol tcp \
  --dst-port 80 \
  --remote-ip 0.0.0.0/0 \
  $SG_NAME

enter "Destroy the Security Group"


openstack security group delete $SG_NAME
