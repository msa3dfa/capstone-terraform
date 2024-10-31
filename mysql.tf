resource "alicloud_instance" "mysql" {
  availability_zone          = data.alicloud_zones.avail_zones.zones.0.id
  security_groups            = [alicloud_security_group.mysql.id]

  instance_type              = "ecs.g6.large"
  system_disk_category       = "cloud_essd"
  system_disk_size           = 40
  image_id                   = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
  instance_name              = "mysql"
  vswitch_id                 = alicloud_vswitch.private.id
  internet_max_bandwidth_out = 0
  internet_charge_type       = "PayByBandwidth"
  instance_charge_type       = "PostPaid"
  key_name                   = alicloud_ecs_key_pair.capstone_key.id
  user_data                  = base64encode(templatefile("mysql_startup.tpl", { root_password = var.mysql_root_password, database = var.mysql_database }))
}

output "mysql-private-ip" {
  value = alicloud_instance.mysql.private_ip
}
