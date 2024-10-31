resource "alicloud_instance" "bastion" {
  availability_zone          = data.alicloud_zones.avail_zones.zones.0.id
  security_groups            = [alicloud_security_group.bastion.id]

  instance_type              = "ecs.g6.large"
  system_disk_category       = "cloud_essd"
  system_disk_size           = 40
  image_id                   = "ubuntu_24_04_x64_20G_alibase_20240812.vhd"
  instance_name              = "Bastion"
  vswitch_id                 = alicloud_vswitch.public.id
  internet_max_bandwidth_out = 100
  internet_charge_type       = "PayByBandwidth"
  instance_charge_type       = "PostPaid"
  status                     = "Running"
  key_name                   = alicloud_ecs_key_pair.capstone_key.id 
}

output "bastion_public_ip" {
  value = alicloud_instance.bastion.public_ip
}
