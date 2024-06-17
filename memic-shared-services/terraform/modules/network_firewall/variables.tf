variable "inspection_vpc_id" {
  description = "Inspection VPC ID"
}

variable "inspection_subnet" {
  description = "Inspection subnets"
  type        = list(any)
}

variable "tags_for_all" {
  type    = map(any)
  default = {}
}

variable "nfw_policy_arn" {
  type    = string
  default = ""
}


