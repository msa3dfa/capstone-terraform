resource "alicloud_security_group" "web" {
  name   = "Web_App_Security_Group"
  vpc_id = alicloud_vpc.my-vpc.id
}

resource "alicloud_security_group_rule" "allow_ssh_to_web_from_bastion" {
  type                     = "ingress"
  ip_protocol              = "tcp"
  policy                   = "accept"
  port_range               = "22/22"
  priority                 = 1
  security_group_id        = alicloud_security_group.web.id
  source_security_group_id = alicloud_security_group.bastion.id
}

resource "alicloud_security_group_rule" "allow_http_to_web" {
  type               = "ingress"
  ip_protocol        = "tcp"
  policy             = "accept"
  port_range         = "80/80"
  priority           = 1
  security_group_id  = alicloud_security_group.web.id
  cidr_ip         = "0.0.0.0/0"
}
