/**
  * # TGW-ASSO-PROP Module
  * 
  * This is the readme of the aws transit gateway association and propagation module. This module can be used to create tgw route table association, propagation and tgw static routes.
  *
  * The behaviour of the module can be changed by adjusting the value of `count` variables `tgw_associations`, `tgw_propagations`, `active_static_routes` and `blackhole_static_routes`. Variables of resources disabled via the `count` variables will then be optional.
  */


#------- Transit Gateway Route Table Propogation ----------#



resource "aws_ec2_transit_gateway_route_table_association" "tgw_association" {
  count                          = length(var.tgw_associations)
  transit_gateway_attachment_id  = element(var.tgw_associations, count.index)
  transit_gateway_route_table_id = var.tgw_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_propagation" {
  count                          = length(var.tgw_propogations)
  transit_gateway_attachment_id  = element(var.tgw_propogations, count.index)
  transit_gateway_route_table_id = var.tgw_route_table_id
}

# --------- TGW static route -----------#

resource "aws_ec2_transit_gateway_route" "active_static_routes" {
  count                          = length(var.active_static_routes)
  transit_gateway_attachment_id  = var.active_static_routes[count.index]["tgw_attachment"]
  transit_gateway_route_table_id = var.tgw_route_table_id
  destination_cidr_block         = var.active_static_routes[count.index]["cidr"]
}

resource "aws_ec2_transit_gateway_route" "blackhole_static_routes" {
  count                          = length(var.blackhole_static_routes)
  transit_gateway_route_table_id = var.tgw_route_table_id
  destination_cidr_block         = var.blackhole_static_routes[count.index]["cidr"]
  blackhole                      = true
}
