variable "transit_gateway_route_table_id" {
  description = "The list of TGW route table ids for aws route"
  type        = string
  default     = ""
}

variable "destination_cidr_block" {
  description = "Destination CIDR block for TGW route table"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "transit_gateway_attachment_id" {
  description = "Transit gateway attachment id for TGW route table"
  type        = list(any)
  default     = [""]
}

variable "blackhole" {
  description = "Transit gateway attachment id for TGW route table"
  type        = list(any)
  default     = []
}

