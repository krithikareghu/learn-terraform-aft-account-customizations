variable "route_table_id" {
  description = "The list of vpc route table ids for aws route"
  type        = string
  default     = ""
}

variable "destination_cidr_block" {
  description = "Destination CIDR block for VPC route table"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "transit_gateway_id" {
  description = "Transit gateway id for VPC route table"
  type        = string
  default     = ""
}

