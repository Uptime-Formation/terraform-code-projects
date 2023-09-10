# HTTPS listener and pool


data "openstack_keymanager_secret_v1" "certification_tls_cert" {
  name        = "certification_tls_cert"
}

resource "openstack_lb_listener_v2" "certification_listener_https" {
  name                      = "certification_listener_tls"
  protocol                  = "TERMINATED_HTTPS"
  protocol_port             = 443
  loadbalancer_id           = openstack_lb_loadbalancer_v2.certification_lb.id
  default_tls_container_ref = data.openstack_keymanager_secret_v1.certification_tls_cert.secret_ref
  sni_container_refs        = []
  insert_headers            = {
    X-Forwarded-For = "true"
  }
}

resource "openstack_lb_pool_v2" "certification_pool_https" {
  name        = "certification_pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.certification_listener_https.id
}

resource "openstack_lb_members_v2" "certification_pool_members_https" {
  pool_id = openstack_lb_pool_v2.certification_pool_https.id
  dynamic "member" {
    for_each = toset(local.instances)
    content {
      name          = member.value
      address       = openstack_compute_instance_v2.certification_instances[member.value].access_ip_v4
      protocol_port = 9000
    }
  }

}

resource "openstack_lb_monitor_v2" "certification_monitor_https" {
  name             = "certification_monitor"
  pool_id          = openstack_lb_pool_v2.certification_pool_https.id
  delay            = 20
  timeout          = 10
  max_retries      = 5
  max_retries_down = 3
  type             = "HTTP"
  url_path         = "/"
  http_method      = "GET"
  expected_codes   = "200"
}
