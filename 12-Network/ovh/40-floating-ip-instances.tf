
data "openstack_networking_subnet_ids_v2" "ext_subnets" {
  network_id = data.openstack_networking_network_v2.extnet.id
  depends_on = [
    openstack_networking_subnet_v2.subnet_1
  ]
}


resource "openstack_networking_floatingip_v2" "certification_ip" {
  pool       = data.openstack_networking_network_v2.extnet.name
  subnet_ids = data.openstack_networking_subnet_ids_v2.ext_subnets.ids
}

#resource "openstack_compute_floatingip_associate_v2" "blue_association" {
#  floating_ip = openstack_networking_floatingip_v2.certification_ip.address
#  instance_id = openstack_compute_instance_v2.certification_instances["blue"].id
#}

resource "openstack_compute_floatingip_associate_v2" "green_association" {
  floating_ip = openstack_networking_floatingip_v2.certification_ip.address
  instance_id = openstack_compute_instance_v2.certification_instances["green"].id
}


output "floating_ip" {
  value = openstack_networking_floatingip_v2.certification_ip.address
}