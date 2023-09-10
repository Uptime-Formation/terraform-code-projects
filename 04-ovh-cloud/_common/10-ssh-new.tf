resource "openstack_compute_keypair_v2" "certification_key" {
  name       = var.ovh_ssh_key_name
  public_key = file(var.ovh_ssh_key_path) # Path to your previously generated SSH key
}
