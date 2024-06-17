/**
  * # VPC Module
  * 
  * This is the readme of the aws vpc module. This module can be used to create vpc's with public and private subnets, dhcp options, security groups and then vpc endpoints.
  *
  * The behaviour of the module can be changed by adjusting the value of `count` via `vpc_cidr`, `private_cidr`, `public_cidr`, `enable_vpc_flow_log`  and `create_dhcpoption_set` variables. Variables defined for the disabled resources will then be optional.
  */



#------ VPC --------#
resource "aws_vpc" "vpc" {
  count                            = length(var.vpc_cidr) > 0 ? length(var.vpc_cidr) : 0
  cidr_block                       = element(var.vpc_cidr, count.index)
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Virtual Private Cloud")}-${var.vpc_name}-${var.account_number}-${lookup(var.region_short_form, "us-east-1")}"
    flowlog   = var.traffic_type
   
  })
}


#--------- PRIVATE SUBNET ----------#

resource "aws_subnet" "private_subnet" {
  count                           = length(var.private_cidr)
  vpc_id                          = aws_vpc.vpc[0].id
  cidr_block                      = element(var.private_cidr, count.index)
  availability_zone               = element(var.region_azs, count.index)
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.private_subnet_assign_ipv6_address_on_creation
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Subnet")}-${element(var.private_subnet_names, count.index)}-${element(var.region_azs, count.index)}"
   
  })
}


#--------- PUBLIC SUBNET ---------#

resource "aws_subnet" "public_subnet" {
  count                           = length(var.public_cidr)
  vpc_id                          = aws_vpc.vpc[0].id
  cidr_block                      = element(var.public_cidr, count.index)
  availability_zone               = element(var.region_azs, count.index)
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.public_subnet_assign_ipv6_address_on_creation
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Subnet")}-${element(var.public_subnet_names, count.index)}-${element(var.region_azs, count.index)}"
   
  })
}

#-------- PUBLIC ROUTE TABLE - Public Subnets ------- #

resource "aws_route_table" "public_route_table" {
  count  = length(var.public_route_table_names)
  vpc_id = aws_vpc.vpc[0].id

  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Route Table")}-${element(var.public_subnet_names, count.index)}-${element(var.region_azs, count.index)}"
   
  })
}

#------------ PUBLIC ROUTE ------------- #

resource "aws_internet_gateway" "main_igw" {
  count  = var.enable_igw && length(aws_route_table.public_route_table.*.id) > 0 ? 1 : 0
  vpc_id = element(aws_vpc.vpc.*.id, count.index)

  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Internet Gateway")}-${var.vpc_name}-${lookup(var.region_short_form, "us-east-1")}"
   
  })
}

resource "aws_route" "public_route" {
  count                  = var.enable_igw && length(aws_route_table.public_route_table.*.id) > 0 ? length(aws_route_table.public_route_table.*.id) : 0
  route_table_id         = aws_route_table.public_route_table[count.index].id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.main_igw[0].id
  timeouts {
    create = "5m"
  }
}

#---------- ROUTE TABLE ASSOCIATION - Public Subnets ---------- #

resource "aws_route_table_association" "pub_route_associate" {
  count          = length(var.public_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table[0].id
}

#----------- PRIVATE ROUTE TABLE  - Private Subnets ------------ #

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_route_table_names)
  vpc_id = aws_vpc.vpc[0].id

  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Route Table")}-${element(var.private_subnet_names, count.index)}-${element(var.region_azs, count.index)}"
   
  })
}

#--------- PRIVATE ROUTE ------------#

#  creating an elastic ip
resource "aws_eip" "nat_ip" {
  count = var.enable_nat_gateway && length(var.region_azs) > 0 ? length(var.region_azs) : 0
  vpc   = true
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Elastic IP")}-${lookup(var.resource_short_form, "NAT gateway")}-${element(var.region_azs, count.index)}"
  
  })
}
# creating an nat gateway
resource "aws_nat_gateway" "iac_default_ng" {
  count         = var.enable_nat_gateway && length(var.region_azs) > 0 ? length(var.region_azs) : 0
  allocation_id = element(aws_eip.nat_ip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "NAT gateway")}-${element(var.region_azs, count.index)}"
   
  })
}

resource "aws_route" "private_route" {
  count                  = var.enable_nat_gateway && length(var.region_azs) > 0 ? length(var.region_azs) : 0
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = element(aws_nat_gateway.iac_default_ng.*.id, count.index)
  timeouts {
    create = "5m"
  }
}

#--------- ROUTE TABLE ASSOCIATION -Private Subnets----------#

resource "aws_route_table_association" "prv_route_associate" {
  count          = length(var.private_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table[0].id
}

#------- VPC FLOW LOGS --------#

resource "aws_flow_log" "flow_log" {
  count                = var.enable_vpc_flow_log ? 1 : 0
  traffic_type         = var.traffic_type
  vpc_id               = aws_vpc.vpc[0].id
  log_destination_type = var.log_destination_type
  log_destination      = var.vpc_flow_log_destination
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Flow Log")}-${var.vpc_name}-${lookup(var.region_short_form, "us-east-1")}-${aws_vpc.vpc[0].tags_all["Name"]}"
   
  })
}


#---------- DHCP Option Set -------------#

resource "aws_vpc_dhcp_options" "dhcp_set" {
  count       = var.create_dhcpoption_set ? 1 : 0
  domain_name = var.domain_name
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "DHCP Option sets")}-${var.vpc_name}-${lookup(var.region_short_form, "us-east-1")}"
   
  })
}

resource "aws_vpc_dhcp_options_association" "dhcp_associate" {
  count           = var.create_dhcpoption_set ? 1 : (var.create_dhcpoption_association ? 1 : 0)
  vpc_id          = aws_vpc.vpc[0].id
  dhcp_options_id = var.create_dhcpoption_set ? aws_vpc_dhcp_options.dhcp_set[0].id : var.dhcp_option_set_id
}


#-------- GATEWAY ENDPOINT --------#

resource "aws_vpc_endpoint" "vpc_gateway_endpoint" {
  count              = var.create_vpc_endpoint && length(var.private_cidr) > 0 ? 1 : 0
  vpc_id             = element(aws_vpc.vpc.*.id, count.index)
  service_name       = "com.amazonaws.us-east-1.${var.vpc_endpoint_service_name}"
  vpc_endpoint_type  = var.vpc_endpoint_type
  route_table_ids    = var.vpc_endpoint_type == "Gateway" ? flatten([aws_route_table.private_route_table.*.id]) : null
  subnet_ids         = var.vpc_endpoint_type == "Interface" ? flatten([aws_subnet.private_subnet.*.id]) : null
  security_group_ids = var.vpc_endpoint_type == "Interface" ? flatten([aws_security_group.sec_grp.*.id]) : null
  auto_accept        = true
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Gateway Endpoint")}-s3-${var.vpc_name}-${lookup(var.region_short_form, "us-east-1")}-0${count.index + 1}"
   
  })
}



#------------ SECURITY GROUP ----------#

resource "aws_security_group" "sec_grp" {
  count       = length(var.vpc_cidr)
  name        = "scg-${var.vpc_name}-${lookup(var.region_short_form, "us-east-1", "")}"
  description = var.sg_description
  vpc_id      = element(aws_vpc.vpc.*.id, count.index)
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Security Group")}-${var.vpc_name}-${lookup(var.region_short_form, "us-east-1", "")}"
   
  })
  dynamic "ingress" {
    for_each = var.sg_ingress_rule
    content {
      description = try(ingress.value["description"], "")
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = flatten([ingress.value["cidr_blocks"]])
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress_rule
    content {
      description = try(egress.value["description"], "")
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = flatten([egress.value["cidr_blocks"]])
    }
  }
}


#----------- DEFAULT SECURITY GROUP --------- #

resource "aws_default_security_group" "default" {
  count  = length(var.vpc_cidr)
  vpc_id = element(aws_vpc.vpc.*.id, count.index)
  tags = merge(var.tags_for_all, {
    Name      = "default-${lookup(var.resource_short_form, "Security Group")}-${var.vpc_name}-${lookup(var.region_short_form, "us-east-1", "")}"
   
  })
}
