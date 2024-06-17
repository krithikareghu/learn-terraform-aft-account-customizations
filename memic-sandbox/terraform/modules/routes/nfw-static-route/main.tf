/**
  * # NFW-Static-Route Module
  * 
  * This is the readme of the aws nfw static route module. This module is used to do static routes for the nfw by providing its `vpc_endpoint_id`, `destination_cidr_block` and `route_table_id`.
  */

# ---------- Network Firewall Routes -------------

resource "aws_route" "nfw-route" {
  destination_cidr_block = var.destination_cidr_block
  route_table_id         = var.route_table_id
  vpc_endpoint_id        = var.nfw_endpoint_id
}


