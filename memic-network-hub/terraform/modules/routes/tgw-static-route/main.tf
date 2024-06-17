/**
  * # TGW-Static-Route Module
  * 
  * This is the readme of the aws tgw static route module. This module is used to do static routes for the tgw by providing its `transit_gateway_route_table_id` and `transit_gateway_attachment_id`.
  */

# ---------- Transit Gateway Static Routes -------------

# resource "aws_ec2_transit_gateway_route" "tgw-static-route" {
#   count                  = length(var.destination_cidr_block)
#   destination_cidr_block = var.destination_cidr_block[count.index]
#   dynamic "attachment" {
#     for_each = var.blackhole[count.index] == false ? [1] : []
#     content {
#       transit_gateway_attachment_id = var.transit_gateway_attachment_id[count.index]
#     }
#   }
#   transit_gateway_route_table_id = var.transit_gateway_route_table_id
#   blackhole                      = var.blackhole[count.index]
# }