resource "alicloud_security_group" "mysql" {
  name   = "MySQL_DB_Security_Group"
  vpc_id = alicloud_vpc.my-vpc.id
}

resource "alicloud_security_group_rule" "allow_ssh_to_mysql_from_bastion" {
  type                     = "ingress"
  ip_protocol              = "tcp"
  policy                   = "accept"
  port_range               = "22/22"
  priority                 = 1
  security_group_id        = alicloud_security_group.mysql.id
  source_security_group_id = alicloud_security_group.bastion.id
}

 resource "alicloud_security_group_rule" "allow_web_mysql_db" {
   type                     = "ingress"
   ip_protocol              = "tcp"
   policy                   = "accept"
   port_range               = "3306/3306"
   priority                 = 1
   security_group_id        = alicloud_security_group.mysql.id
   source_security_group_id = alicloud_security_group.web.id
 }
