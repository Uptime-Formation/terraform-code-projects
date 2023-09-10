
data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  network_id = data.openstack_networking_network_v2.extnet.id
}


resource "openstack_networking_floatingip_v2" "certification_ip" {
  pool       = data.openstack_networking_network_v2.extnet.name
  subnet_ids = data.openstack_networking_subnet_ids_v2.ext_subnets.ids
}

resource "openstack_networking_floatingip_associate_v2" "lb_association" {
  floating_ip = openstack_networking_floatingip_v2.certification_ip.address
  port_id = openstack_lb_loadbalancer_v2.certification_lb.vip_port_id
}


output "floating_ip" {
  value = openstack_networking_floatingip_v2.certification_ip.address
}