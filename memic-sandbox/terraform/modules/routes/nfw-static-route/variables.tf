variable "route_table_id" {
  description = "The NFW route table id for aws route"
  type        = string
}

variable "destination_cidr_block" {
  description = "Destination CIDR block for NFW route table"
  type        = string
}

variable "nfw_endpoint_id" {
  description = "Network Firewall Endpoint id for route table"
  type        = string
}

