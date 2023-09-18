resource scaleway_vpc_private_network "public_network" {
  name = "myprivatenetwork"
  zone = "fr-par-1"
}

resource scaleway_vpc_public_gateway_dhcp "dhcp" {
  subnet         = "192.168.1.0/24"
  dns_local_name = scaleway_vpc_private_network.public_network.name
}

resource scaleway_vpc_public_gateway_ip "public_gateway_ip" {
}

resource scaleway_vpc_public_gateway "public_gateway" {
  type            = "VPC-GW-S"
  bastion_enabled = true
  ip_id           = scaleway_vpc_public_gateway_ip.public_gateway_ip.id
}

resource scaleway_vpc_gateway_network "gateway_network" {
  gateway_id         = scaleway_vpc_public_gateway.public_gateway.id
  private_network_id = scaleway_vpc_private_network.public_network.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.dhcp.id
  enable_dhcp        = true
}


output "connection" {
  value = "Connect using: ssh -J bastion@${scaleway_vpc_public_gateway_ip.public_gateway_ip.address}:61000 root@server-<0...n>.myprivatenetwork"
}