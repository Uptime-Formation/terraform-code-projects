data "openstack_images_image_v2" "some_distro" {
  name = "Ubuntu 23.04"
}

resource "openstack_compute_instance_v2" "certification_instance" {
  name        = "terraform_instance"
  image_id    = data.openstack_images_image_v2.some_distro.id
  flavor_name = "d2-2"
  key_pair    = openstack_compute_keypair_v2.certification_key.name
  network {
    name = "Ext-Net"
  }
}

output "instance_addresses" {
  value = openstack_compute_instance_v2.certification_instance.access_ip_v4
}
