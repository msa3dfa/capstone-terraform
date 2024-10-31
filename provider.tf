provider "alicloud" {
   access_key = var.access_key
   secret_key = var.secret_key
   region     = "me-central-1"
}

data "alicloud_zones" "avail_zones" {
   available_disk_category     = "cloud_efficiency"
   available_resource_creation = "VSwitch"
}
