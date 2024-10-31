resource "alicloud_vpc" "my-vpc" {
    vpc_name = "my-vpc"
    cidr_block = "10.0.0.0/8"
}

# Vswitches
resource "alicloud_vswitch" "public" {
    vswitch_name = "public vswitch"
    vpc_id       = alicloud_vpc.my-vpc.id
    cidr_block   = "10.0.1.0/24"
    zone_id      = data.alicloud_zones.avail_zones.zones.0.id
}

resource "alicloud_vswitch" "private" {
    vswitch_name = "private vswitch"
    vpc_id       = alicloud_vpc.my-vpc.id
    cidr_block   = "10.0.2.0/24"
    zone_id      = data.alicloud_zones.avail_zones.zones.0.id
}

resource "alicloud_vswitch" "public-b" {
    vswitch_name = "public-b vswitch"
    vpc_id       = alicloud_vpc.my-vpc.id
    cidr_block   = "10.0.3.0/24"
    zone_id      = data.alicloud_zones.avail_zones.zones.1.id
}

# NAT gateway
resource "alicloud_nat_gateway" "default" {
    vpc_id           = alicloud_vpc.my-vpc.id
    vswitch_id       = alicloud_vswitch.public.id
    nat_gateway_name = "my-nat"
    nat_type         = "Enhanced"
    payment_type     = "PayAsYouGo"
}

resource "alicloud_eip_address" "nat-eip" {
    description          = "Nat eip address"
    isp                  = "BGP"
    netmode              = "public"
    bandwidth            =  "1"
    payment_type         = "PayAsYouGo"
    internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "nat-eip-assc" {
  allocation_id = alicloud_eip_address.nat-eip.id
  instance_id   = alicloud_nat_gateway.default.id
  instance_type = "Nat"
}

resource "alicloud_snat_entry" "private" {
  snat_table_id     = alicloud_nat_gateway.default.snat_table_ids
  source_vswitch_id = alicloud_vswitch.private.id
  snat_ip           = alicloud_eip_address.nat-eip.ip_address
}

# Adding nat gateway as next hop in private vswitch route table

resource "alicloud_route_table" "private" {
  vpc_id           = alicloud_vpc.my-vpc.id  
  route_table_name = "Private Route Table"
  associate_type   = "VSwitch"
}

resource "alicloud_route_entry" "private" {
  route_table_id        = alicloud_route_table.private.id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NatGateway"
  nexthop_id            = alicloud_nat_gateway.default.id
}

resource "alicloud_route_table_attachment" "private" {
  vswitch_id     = alicloud_vswitch.private.id
  route_table_id = alicloud_route_table.private.id
}
