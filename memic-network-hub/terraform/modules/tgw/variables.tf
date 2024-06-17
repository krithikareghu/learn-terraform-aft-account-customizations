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

# --------------- transit gateway variables --------------

variable "amazon_side_asn" {
  description = "ASN for the Amazon side of a BGP session"
  type        = string
  default     = "64512"
}

variable "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = string
  default     = "disable"
}

variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table."
  type        = string
  default     = "disable"
}

variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table."
  type        = string
  default     = "disable"
}

variable "dns_support" {
  description = "Whether DNS support is enabled."
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled."
  type        = string
  default     = "enable"
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
  default     = ""
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

# --------------  tgw route table --------------

variable "create_rt" {
  description = "This should be true to create transit gateway route table."
  type        = bool
  default     = true

}

variable "tgw_rt_tables" {
  description = "The list of route table names to be created"
  type        = list(any)
  default     = [""]
}

# --------------- vpn attachment --------------

variable "create_vpn" {
  description = "Whether or not to create vpn."
  type        = bool
  default     = false
}

variable "customer_gateway_id" {
  description = "Id for customer gateway"
  type        = string
  default     = ""
}

variable "vpn_ips" {
  description = "List of VPN ip's for which you want a VPN Connection."
  type        = list(any)
  default     = [""]
}

variable "vpn_type" {
  description = "List of The types of the VPN connections. The only type AWS supports at this time is 'ipsec.1'."
  type        = string
  default     = "ipsec.1"
}

variable "static_route_enable" {
  description = "List of Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP."
  type        = bool
  default     = true
}

# -------------- direct connect --------------

variable "create_dx" {
  description = "Whether or not to create direct connect association."
  type        = bool
  default     = false
}

variable "dx_gateway_id" {
  description = "Direct connect gateway id"
  type        = string
  default     = ""
}

variable "allowed_prefixes" {
  description = "VPC prefixes (CIDRs) to advertise to the Direct Connect gateway."
  type        = list(string)
  default     = [""]
}

# -------------- ram resource variables --------------

# Resource Access Manager Variables

variable "create_ram" {
  description = "To create RAM resource"
  type        = bool
  default     = false
}

variable "ram_name" {
  description = "Resource Access Manager Share Name"
  type        = string
}

variable "share_resource_arn" {
  description = "ARN of resources to be shared via RAM"
  type        = list(any)
  default     = []
}

variable "ram_principals" {
  description = "A list of principals to share resources. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(any)
  default     = []
}

variable "allow_external_principals" {
  description = "To allow_external_principals"
  type        = bool
  default     = false
}

variable "share_tgw" {
  description = "To share tgw via ram. set it true if resource_share_arn is available"
  type        = bool
  default     = false
}

variable "resource_share_arn" {
  description = "ARN of the ram resources that have been shared"
  type        = string
  default     = ""
}
