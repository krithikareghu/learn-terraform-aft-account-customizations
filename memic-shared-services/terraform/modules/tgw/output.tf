
output "transit_gateway_arn" {
  value       = try(aws_ec2_transit_gateway.main_tgw.*.arn, "")
  description = "Transit Gateway ARN"
}

output "transit_gateway_id" {
  value       = try(aws_ec2_transit_gateway.main_tgw.*.id, "")
  description = "Transit Gateway ID"
}

output "transit_gateway_route_table_id" {
  value       = try(aws_ec2_transit_gateway_route_table.transitGatewayRoutetable.*.id, "")
  description = "Transit Gateway route table ID"
}

output "transit_gateway_vpc_attachment_ids" {
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_attachement.*.id
  description = "Transit Gateway VPC attachment IDs"
}