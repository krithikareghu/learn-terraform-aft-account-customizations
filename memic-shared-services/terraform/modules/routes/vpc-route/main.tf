/**
  * # VPC-Route Module
  * 
  * This is the readme of the aws vpc route module. This module is used to attach transit gateway with vpc route table by providing the `transit_gateway_id` and vpc's `route_table_id`.
  */

# ---------- VPC Routes -------------

resource "aws_route" "tgw_routes" {
  count                  = length(var.destination_cidr_block)
  transit_gateway_id     = var.transit_gateway_id
  route_table_id         = var.route_table_id
  destination_cidr_block = var.destination_cidr_block[count.index]

  timeouts {
    create = "5m"
  }
}
