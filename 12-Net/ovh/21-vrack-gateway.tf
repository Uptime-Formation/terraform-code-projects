data "openstack_networking_network_v2" "extnet" {
  name = "Ext-Net"
}

resource "openstack_networking_network_v2" "certification_net" {
  name           = var.vrack_network_name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  network_id      = openstack_networking_network_v2.certification_net.id
  cidr            = var.vrack_range
  dns_nameservers = ["1.1.1.1"]
  ip_version      = 4
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "certification_router"
  external_network_id = data.openstack_networking_network_v2.extnet.id
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

output "public_net" {
  value = data.openstack_networking_network_v2.extnet.id
}
output "private_net" {
  value = openstack_networking_subnet_v2.subnet_1.id
}
output "gateway_ip" {
  value = openstack_networking_router_v2.router_1.external_fixed_ip[0].ip_address
}