data "openstack_compute_keypair_v2" "certification_key" {
  name = var.ovh_ssh_key_name
}
