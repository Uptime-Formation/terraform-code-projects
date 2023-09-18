data "openstack_networking_secgroup_v2" "default" {
  region = var.openstack_region
  name = "default"
}
resource "openstack_networking_secgroup_v2" "certification_secgroup" {
  name        = "certification_secgroup"
  description = "My neutron security group"
  delete_default_rules = true
}
