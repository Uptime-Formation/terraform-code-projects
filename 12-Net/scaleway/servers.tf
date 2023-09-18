
resource scaleway_instance_server "servers" {
  count = var.machine_count
  name  = "server-${count.index}"
  image = "ubuntu_focal"
  type  = var.machine_flavor
}

resource scaleway_instance_private_nic "nic" {
  count              = length(scaleway_instance_server.servers)
  private_network_id = scaleway_vpc_private_network.public_network.id
  server_id          = scaleway_instance_server.servers[count.index].id
}
