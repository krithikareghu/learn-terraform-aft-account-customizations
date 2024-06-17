output "tgw_route_table_association_id" {
  description = "The id of the associations created on the TGW route table"
  value       = aws_ec2_transit_gateway_route_table_association.tgw_association.*.id
}

output "tgw_route_table_propagation_id" {
  description = "The id of the propagations created on the TGW route table"
  value       = aws_ec2_transit_gateway_route_table_propagation.tgw_propagation.*.id
}

