locals {
  # Create lookup maps so we can route AZ traffic to it's appropriate NWFW endpoint
  # NWFW declares where it's ENIs are per-AZ, so we need a lookup map against appropriate keys from attachment_subnet map
  eni_lookup = { for state in aws_networkfirewall_firewall.inspection_vpc_network_firewall.firewall_status[0].sync_states : state.availability_zone => state.attachment[0].endpoint_id }
}
