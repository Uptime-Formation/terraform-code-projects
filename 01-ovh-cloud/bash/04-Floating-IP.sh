# /bin/bash
panic(){ echo -e "\n$@\n"; exit; }
enter(){ echo; read -p "Type enter to run operation: $@"; }

INSTANCE_NAME="cert-instance-shell"
[[ -z "$OS_USERNAME" ]] && panic "Please source the OpenStack RC file. Please visit: \nhttps://help.ovhcloud.com/csm/en-public-cloud-compute-set-openstack-environment-variables?id=kb_article_view&sysparm_article=KB0050920"

enter "Create the Floating IP "

openstack floating ip create "Ext-Net"

enter "List the Floating IP "

openstack floating ip list

read -e -p "Enter the newIP address: " IP_ADDR

cat  << EOF

You would use the following syntax to add the IP to an instance

$ openstack server add floating ip my_instance "$IP_ADDR"

EOF

enter "Destroy the IP"

openstack floating ip delete "$IP_ADDR"

EOF