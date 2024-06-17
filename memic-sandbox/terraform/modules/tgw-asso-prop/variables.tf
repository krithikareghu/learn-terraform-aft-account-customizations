# --------------- variables for all resources --------------- 
variable "account_name" {
  description = "Account Name for resource naming"
  type        = string
  default     = "network-account"
}

variable "resource_short_form" {
  description = "Short form of resources for naming "
  type        = map(any)
  default = {
    "Virtual Private Cloud" : "vpc",
    "Subnet" : "sub",
    "Route Table" : "rt",
    "Transit Gateway" : "tgw",
    "Transit Gateway route table" : "tgw-rtb"
  }
}

variable "region_short_form" {
  description = "Short form of the regions "
  type        = map(any)
  default = {
    "us-east-1" : "use1",
  }
}

variable "create_transit_gateway" {
  description = "Whether or not to create Transit gateway."
  type        = bool
  default     = false
}

variable "tags_for_all" {
  description = "tags for all resources"
  type        = map(any)
  default     = {}
}

variable "tgw_associations" {
  description = "Transit Gateway Associations for Route Table"
  type        = list(string)
}

variable "tgw_propogations" {
  description = "Transit Gateway Associations for Route Table"
  type        = list(string)
}

variable "tgw_route_table_id" {
  description = "Transit Gateway Route Table ID"
  type        = string
}

variable "create_static_rt" {
  description = "To create static route in tgw route table"
  type        = bool
  default     = false
}

variable "active_static_routes" {
  description = "Active Static routes in tgw route tables"
  type        = list(any)
  default     = []
}

variable "blackhole_static_routes" {
  description = "Blackhole Static routes in tgw route tables"
  type        = list(any)
  default     = []
}


# --------------- tgw vpc attachments --------------

variable "vpc_names" {
  description = "The list of vpc names to be attached with TGW"
  type        = list(string)
  default     = []
}

variable "tgw_attachment_names" {
  description = "The list of tgw attachment names to be attached with TGW"
  type        = list(string)
  default     = []
}
variable "tgw_attachments_id" {
  description = ""
  type = list(string)
  default = []
}

variable "vpc_id" {
  description = "The list of vpc id's to be attached with TGW"
  type        = list(any)
  default     = []
}

variable "subnet_id" {
  description = "The list of subnets"
  type        = list(any)
  default     = []
}

variable "transit_gateway_id" {
  description = "The id of Transit Gateway"
  type        = string
}

variable "transit_gateway_default_route_table_association" {
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table."
  type        = bool
  default     = false
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table."
  type        = bool
  default     = false
}

variable "vpc_attachment_dns_support" {
  description = "Whether DNS support is enabled for attachments"
  type        = string
  default     = "disable"
}

variable "vpc_attachment_ipv6_support" {
  description = "Whether IPv6 support is enabled for attachments"
  type        = string
  default     = "disable"
}

variable "appliance_mode_support" {
  description = "Whether Appliance Mode support is enabled. Valid values: disable, enable"
  type        = string
  default     = "disable"
  validation {
    condition     = contains(["enable", "disable"], var.appliance_mode_support)
    error_message = "`appliance_mode_support` must be one of: \"enable\", \"disable\"."
  }
}