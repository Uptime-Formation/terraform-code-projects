resource "openstack_compute_keypair_v2" "new_key" {
  name       = "mynewkey"
  public_key = file("/home/alban/.ssh/id_rsa.octo.pub") # Path to your previously generated SSH key
}

