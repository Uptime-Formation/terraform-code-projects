# /bin/bash
panic(){ echo -e "\n$@\n"; exit; }
enter(){ echo; read -p "Type enter to run operation: $@"; }

[[ -z "$OS_USERNAME" ]] && panic "Please source the OpenStack RC file. Please visit: \nhttps://help.ovhcloud.com/csm/en-public-cloud-compute-set-openstack-environment-variables?id=kb_article_view&sysparm_article=KB0050920"

LB_NAME="cert-lb-shell"
LISTENER_NAME="cert-listener-shell"
POOL_NAME="cert-pool-shell"

enter "Get the private Subnets"

openstack subnet list | grep -v "Ext-Net"

read -p "Please provide the private network to use: " PRIVATE_NET

enter "Create the Load Balancer"

openstack loadbalancer create --name "$LB_NAME" --flavor small --vip-subnet-id "$PRIVATE_NET"

while true; do
    openstack loadbalancer list
    read -e -n 1 -p "Is the LoadBalancer active? [y/N]"
    REPLY=${REPLY:-N}
    [[ "Y" == ${REPLY^^} ]] && break
done

enter "Create the listener"

openstack loadbalancer listener create --name "$LISTENER_NAME" --protocol HTTP --protocol-port 80 "$LB_NAME"

enter "Create the pool"

openstack loadbalancer pool create --name "$POOL_NAME" --protocol HTTP --lb-algorithm ROUND_ROBIN --listener "$LISTENER_NAME"

cat << EOF

You would now add your instances to the pool using the following commands:

  openstack loadbalancer member create --subnet-id private-subnet --address 192.0.2.10 --protocol-port 80 "$POOL_NAME"
  openstack loadbalancer member create --subnet-id private-subnet --address 192.0.2.11 --protocol-port 80 "$POOL_NAME"
EOF

enter "Destroy resources"
openstack loadbalancer pool delete "$POOL_NAME"
openstack loadbalancer listener delete "$LISTENER_NAME"
openstack loadbalancer delete "$LB_NAME"


