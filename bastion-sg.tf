resource "alicloud_security_group" "bastion" {
  name = "bastion_sec_group"
  vpc_id = alicloud_vpc.my-vpc.id
}

resource "alicloud_security_group_rule" "allow_ssh_to_bastion" {
  type              = "ingress"
  ip_protocol       = "tcp"
  policy            = "accept"
  port_range        = "22/22"
  cidr_ip           = "0.0.0.0/0"
  priority          = 1
  security_group_id = alicloud_security_group.bastion.id
}
