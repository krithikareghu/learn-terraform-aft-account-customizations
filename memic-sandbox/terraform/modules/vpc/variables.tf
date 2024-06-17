# --------------- Variables for all Resources --------------- 
variable "vpc_name" {
  description = "VPC Name for resource naming"
  type        = string
}

variable "account_number" {
  description = "Account number of accounts"
  type        = string
}

variable "region_short_form" {
  description = "Short form of the regions"
  type        = map(any)
  default = {
    "us-east-1" : "use1",
  }
}

variable "resource_short_form" {
  description = "Short form of resources for naming"
  type        = map(any)
  default = {
    "Virtual Private Cloud" : "vpc",
    "Subnet" : "sub",
    "Route Table" : "rt",
  }
}

variable "tags_for_all" {
  type    = map(any)
  default = {}
}

# --------------- Main VPC variables --------------- 

variable "vpc_cidr" {
  description = "The list of CIDR block for the VPC"
  type        = list(any)
}

variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. Default is false"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC.Defaults true."
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC.Defaults true"
  type        = bool
  default     = true
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC.valid values are default,dedicated and host. Default value is default"
  type        = string
  default     = "default"
}

# --------------- Subnet Variables --------------- 

variable "private_cidr" {
  description = "The list of CIDR block for private subnet"
  type        = list(any)
}

variable "public_cidr" {
  description = "The list of CIDR block for public subnet"
  type        = list(any)
}

# names for public subnets
variable "private_subnet_names" {
  description = "The list of names for private subnet"
  type        = list(any)
}

# names for private subnets
variable "public_subnet_names" {
  description = "The list of names for public subnet"
  type        = list(any)
}

variable "region_azs" {
  description = "List of AWS AZs (Availability zones) for each region"
  type        = list(any)
}

variable "private_subnet_assign_ipv6_address_on_creation" {
  description = "specify whether private subnet should be assigned an IPv6 address. Default is false"
  type        = bool
  default     = false
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  description = "specify whether public subnet should be assigned an IPv6 address. Default is false"
  type        = bool
  default     = false
}

# --------------- Gateway Variables --------------- 

variable "destination_cidr_block" {
  description = "Destination CIDR block for VPC route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_igw" {
  description = "Set it as true to create Internet Gateway associated with Public Subnets. Default is false"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Set it as true to create Nat Gateway associated with Private Subnets. Default is false"
  type        = bool
  default     = false
}

# --------------- VPC flow logs Variables --------------- 

variable "enable_vpc_flow_log" {
  description = "Set it true to enable vpc flow logs"
  type        = bool
  default     = false
}

variable "traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL."
  type        = string
  default     = "ALL"
}

variable "log_destination_type" {
  description = " The type of the logging destination. Valid values: cloud-watch-logs, s3. Default: s3"
  type        = string
  default     = "s3"
}

variable "vpc_flow_log_destination" {
  description = "The ARN of the logging destination."
  type        = string
  default     = ""
}

# --------------- VPC DHCP options Variables --------------- 

variable "create_dhcpoption_set" {
  description = "To create DHCP Option set or not"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for DHCP Option Set. If its true domain_name is required"
  type        = string
  default     = ""
}

variable "dhcp_option_set_id" {
  description = "DHCP option set ID, if incase existing DHCP option set is used"
  default     = ""
  type        = string
}

variable "create_dhcpoption_association" {
  description = "To create DHCP Option Association set or not . If create_dhcpoption_set is true this variable is no need"
  type        = bool
  default     = false
}

# --------------- VPC Endpoint variables --------------- 

variable "create_vpc_endpoint" {
  description = "To create vpc endpoint set it as true"
  type        = bool
  default     = false
}

variable "vpc_endpoint_service_name" {
  description = "The service name ex s3, ssm"
  type        = string
  default     = "s3"
}

variable "vpc_endpoint_type" {
  description = "The type of vpc endpoint valid values are Gateway, Interface"
  type        = string
  default     = "Gateway"
}


# --------------- Security Group variables --------------- 


variable "sg_ingress_rule" {
  description = "Security Group Ingress rule with port, protocol & CIDR blocks"
  type        = list(map(any))
  default     = []
}

variable "sg_egress_rule" {
  description = "Security Group Egress rule with port, protocol & CIDR blocks"
  type        = list(map(any))
  default = [{
    from_port   = 0,
    to_port     = 0,
    protocol    = -1,
    cidr_blocks = "0.0.0.0/0"
  }]
}

variable "region_code" {
  description = "Region Code to build Security Group Naming"
  type        = map(any)
  default     = {}
}

variable "env_code" {
  description = "Environment Code to build Security Group Naming"
  type        = string
  default     = ""
}

variable "os_type" {
  description = "OS Type to build Security Group Naming"
  type        = string
  default     = ""
}

variable "tier" {
  description = "Application Tier to build Security Group Naming"
  type        = string
  default     = ""
}

variable "app_code" {
  description = "Application code to build Security Group Naming"
  type        = string
  default     = ""
}

variable "sg_description" {
  description = "Description of the Security Group"
  type        = string
  default     = "tags"
}

variable "vpc_count_number" {
  description = "vpc count number for tagging purpose"
  type        = number
  default     = 0
}

variable "public_route_table_names" {
  description = ""
  type = list(string)
  
}
variable "private_route_table_names" {
  description = ""
  type = list(string)
}