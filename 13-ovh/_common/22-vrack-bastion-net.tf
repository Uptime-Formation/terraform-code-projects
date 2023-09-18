resource "openstack_networking_network_v2" "certification_bastion_net" {
  name           = var.vrack_bastion_network_name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "bastion_subnet_1" {
  network_id      = openstack_networking_network_v2.certification_bastion_net.id
  cidr            = var.vrack_bastion_range
  dns_nameservers = ["1.1.1.1"]
  ip_version      = 4
}

