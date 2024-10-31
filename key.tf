resource "alicloud_ecs_key_pair" "capstone_key" {
  key_pair_name = "capstone_keyv2"
  key_file      = "capstone_keyv2.pem"
}
