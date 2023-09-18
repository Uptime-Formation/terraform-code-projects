resource "openstack_lb_loadbalancer_v2" "certification_lb" {
  name          = "certification_lb"
  vip_subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

resource "openstack_lb_listener_v2" "certification_listener" {
  name            = "certification_listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.certification_lb.id
  insert_headers  = {
    X-Forwarded-For = "true"
  }

}

resource "openstack_lb_pool_v2" "certification_pool_http" {
  name        = "certification_pool_http"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.certification_listener.id
}

resource "openstack_lb_members_v2" "certification_pool_members" {
  pool_id = openstack_lb_pool_v2.certification_pool_http.id

  dynamic "member" {
    for_each = toset(local.instances)
    content {
      name          = member.value
      address       = openstack_compute_instance_v2.certification_instances[member.value].access_ip_v4
      protocol_port = 9000
    }
  }

}

resource "openstack_lb_monitor_v2" "certification_monitor" {
  name             = "certification_monitor"
  pool_id          = openstack_lb_pool_v2.certification_pool_http.id
  delay            = 20
  timeout          = 10
  max_retries      = 5
  max_retries_down = 3
  type             = "HTTP"
  url_path         = "/"
  http_method      = "GET"
  expected_codes   = "200"
  depends_on = [
    openstack_lb_members_v2.certification_pool_members
  ]
}

output "loadbalancer_address" {
  value = openstack_lb_loadbalancer_v2.certification_lb.vip_address
}