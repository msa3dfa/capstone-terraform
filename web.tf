resource "alicloud_instance" "web" {
  availability_zone          = data.alicloud_zones.avail_zones.zones.0.id
  security_groups            = [alicloud_security_group.web.id]
  count                      = 2

  instance_type              = "ecs.g6.large"
  system_disk_category       = "cloud_essd"
  system_disk_size           = 40
  image_id                   = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
  instance_name              = "web-${count.index}"
  vswitch_id                 = alicloud_vswitch.private.id
  internet_max_bandwidth_out = 0
  internet_charge_type       = "PayByBandwidth"
  instance_charge_type       = "PostPaid"
  key_name                   = alicloud_ecs_key_pair.capstone_key.id 
  user_data                  = base64encode(templatefile("web_startup.tpl", {redis_host  = alicloud_instance.redis.private_ip, mysql_host = alicloud_instance.mysql.private_ip,
                                                                             db_password = var.mysql_root_password, db_name               = var.mysql_database}))
}

output "web_private_ips" {
  value = alicloud_instance.web.*.private_ip
}
