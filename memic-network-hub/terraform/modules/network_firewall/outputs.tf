output "firewall_info" {
  value       = aws_networkfirewall_firewall.inspection_vpc_network_firewall
  description = "Info of network fire for routing"
}

output "firewall_enis" {
  value       = local.eni_lookup
  description = "Network Firewall endpoint IDs"
}
