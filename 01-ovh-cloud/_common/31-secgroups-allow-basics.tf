
resource "openstack_networking_secgroup_rule_v2" "anyout" {
  region            = var.openstack_region
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.certification_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  region            = var.openstack_region
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.certification_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  region            = var.openstack_region
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.certification_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "http-backend" {
  region            = var.openstack_region
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9000
  port_range_max    = 9000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.certification_secgroup.id
}
