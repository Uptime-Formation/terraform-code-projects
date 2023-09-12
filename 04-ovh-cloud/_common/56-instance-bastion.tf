
resource "openstack_compute_instance_v2" "certification_bastion" {
  name        = "certification_bastion"
  image_id    = data.openstack_images_image_v2.some_distro.id
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.certification_key.id
  security_groups = [openstack_networking_secgroup_v2.certification_secgroup.id]
  network {
    uuid = data.openstack_networking_network_v2.extnet.id
  }
  network {
    uuid = openstack_networking_network_v2.certification_bastion_net.id
  }
}


output "bastion_access" {
  value = openstack_compute_instance_v2.certification_bastion.access_ip_v4
}
output "bastion_addresses" {
  value = join(", ", openstack_compute_instance_v2.certification_bastion.network.*.fixed_ip_v4)
}
