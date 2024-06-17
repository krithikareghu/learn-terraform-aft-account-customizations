# Output Variables for VPC

output "vpc_id" {
  description = "List of VPC IDs"
  value       = aws_vpc.vpc.*.id
}

output "dhcp_option_setid" {
  description = "List of DHCP Option Set IDs"
  value       = aws_vpc_dhcp_options.dhcp_set.*.id
}

# Output Variables for Security group

output "sg_id" {
  description = "List of Security Group IDs"
  value       = aws_security_group.sec_grp.*.id
}

# Output Variables for Subnets 

output "private_subnet_ids" {
  description = "List with IDs of the private subnets"
  value       = aws_subnet.private_subnet.*.id
}

output "public_subnet_ids" {
  description = "List with IDs of the public subnets"
  value       = aws_subnet.public_subnet.*.id
}

# Output Variables for Route Tables

output "public_route_table_ids" {
  description = "List of Public Route Table IDs"
  value       = aws_route_table.public_route_table.*.id
}

output "private_route_table_ids" {
  description = "List of Private Route Table IDs"
  value       = aws_route_table.private_route_table.*.id
}

