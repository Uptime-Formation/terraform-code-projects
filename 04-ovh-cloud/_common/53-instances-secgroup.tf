data "openstack_images_image_v2" "some_distro" {
  name = "Ubuntu 23.04"
}


resource "openstack_compute_instance_v2" "certification_instances_blue" {
  name        = "blue"
  image_id    = data.openstack_images_image_v2.some_distro.id
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.certification_key.id
  security_groups = [data.openstack_networking_secgroup_v2.default.name]

  network {
    uuid = openstack_networking_network_v2.certification_bastion_net.id
  }
  network {
    uuid = openstack_networking_network_v2.certification_net.id
  }
}

resource "openstack_compute_instance_v2" "certification_instances_green" {
  name        = "green"
  image_id    = data.openstack_images_image_v2.some_distro.id
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.certification_key.id
  security_groups = [openstack_networking_secgroup_v2.certification_secgroup.name]

  network {
    uuid = openstack_networking_network_v2.certification_bastion_net.id
  }
  network {
    uuid = openstack_networking_network_v2.certification_net.id
  }
}


output "blue_access" {
  value = openstack_compute_instance_v2.certification_instances_blue.access_ip_v4
}

output "blue_addresses" {
  value = join(", ", openstack_compute_instance_v2.certification_instances_blue.network.*.fixed_ip_v4)
}

output "green_access" {
  value = openstack_compute_instance_v2.certification_instances_green.access_ip_v4
}
output "green_addresses" {
  value = join(", ", openstack_compute_instance_v2.certification_instances_green.network.*.fixed_ip_v4)
}
