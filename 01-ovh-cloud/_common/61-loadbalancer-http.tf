resource "openstack_lb_loadbalancer_v2" "certification_lb" {
  name          = "certification_lb"
  vip_subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

# Certboat Listener and Pool

resource "openstack_lb_listener_v2" "certification_listener_http" {
  name            = "certification_listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.certification_lb.id
  insert_headers  = {
    X-Forwarded-For = "true"
  }
}
resource "openstack_lb_pool_v2" "certification_pool_certbot" {
  name        = "certification_pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.certification_listener_http.id
}

resource "openstack_lb_member_v2" "certification_pool_member_certbot" {
  address       = openstack_compute_instance_v2.certification_instances["green"].access_ip_v4
  pool_id       = openstack_lb_pool_v2.certification_pool_certbot.id
  protocol_port = 80
}


resource "openstack_lb_l7policy_v2" "certification_policy_certbot" {
  name        = "certification_policy"
  action      = "REDIRECT_TO_POOL"
  redirect_pool_id = openstack_lb_pool_v2.certification_pool_certbot.id
  listener_id = openstack_lb_listener_v2.certification_listener_http.id
  position = 1
}

resource "openstack_lb_l7rule_v2" "certification_rule_certbot" {
  l7policy_id  = openstack_lb_l7policy_v2.certification_policy_certbot.id
  type         = "PATH"
  compare_type = "STARTS_WITH"
  value        = "/.well-known/acme-challenge"
}

