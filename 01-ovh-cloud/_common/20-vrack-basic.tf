data "ovh_vracks" "vracks" {
}

resource "ovh_cloud_project_network_private" "certification" {
  service_name = var.openstack_project_id
  name         = var.vrack_network_name
  regions      = [var.openstack_region]
  vlan_id      = var.vrack_vlan
  depends_on   = [data.ovh_vracks.vracks]
}

resource "ovh_cloud_project_network_private_subnet" "certification_subnet" {
  service_name = var.openstack_project_id
  network_id   = ovh_cloud_project_network_private.certification.id
  start        = var.vrack_range_start
  end          = var.vrack_range_end
  network      = var.vrack_range
  dhcp         = true
  region       = var.openstack_region
  no_gateway   = true
}

output "vrack" {
  value = data.ovh_vracks.vracks
}
output "network__id" {
  value = ovh_cloud_project_network_private.certification.id
}
output "network_subnet_id" {
  value = ovh_cloud_project_network_private_subnet.certification_subnet.id
}