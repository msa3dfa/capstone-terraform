output "LoadBalancerURL" {
  value = alicloud_nlb_load_balancer.default.dns_name
}
