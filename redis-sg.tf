resource "alicloud_security_group" "redis" {
  name   = "Redis_Security_Group"
  vpc_id = alicloud_vpc.my-vpc.id
}

resource "alicloud_security_group_rule" "allow_ssh_to_redis_from_bastion" {
  type                     = "ingress"
  ip_protocol              = "tcp"
  policy                   = "accept"
  port_range               = "22/22"
  priority                 = 1
  security_group_id        = alicloud_security_group.redis.id
  source_security_group_id = alicloud_security_group.bastion.id
}

resource "alicloud_security_group_rule" "allow_web_to_redis" {
  type                     = "ingress"
  ip_protocol              = "tcp"
  policy                   = "accept"
  port_range               = "6379/6379"
  priority                 = 1
  security_group_id        = alicloud_security_group.redis.id
  source_security_group_id = alicloud_security_group.web.id
}
