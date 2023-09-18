data "openstack_images_image_v2" "some_distro" {
  name = "Ubuntu 23.04"
}

resource "openstack_compute_instance_v2" "certification_instance_blue" {
  name        = "blue"
  image_id    = data.openstack_images_image_v2.some_distro.id
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.certification_key.id

  network {
    name = ovh_cloud_project_network_private.certification.name
  }
}

resource "openstack_compute_instance_v2" "certification_instance_green" {
  name        = "green"
  image_id    = data.openstack_images_image_v2.some_distro.id
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.certification_key.id

  network {
    name = "Ext-Net"
  }
  network {
    name = ovh_cloud_project_network_private.certification.name
  }
}

output "blue_access" {
  value = openstack_compute_instance_v2.certification_instance_blue.access_ip_v4
}

output "blue_addresses" {
  value = join(", ", openstack_compute_instance_v2.certification_instance_blue.network.*.fixed_ip_v4)
}

output "green_access" {
  value = openstack_compute_instance_v2.certification_instance_green.access_ip_v4
}
output "green_addresses" {
  value = join(", ", openstack_compute_instance_v2.certification_instance_green.network.*.fixed_ip_v4)
}