/**
  * # TGW Module
  * 
  * This is the readme of the aws transit gateway module. This module can be used to create tgw, tgw route table and vpc attachments with tgw. Apart from that it can also share the tgw resource to other principals.
  *
  * The behaviour of the module can be changed by adjusting the value of `count` variables `create_transit_gateway`, `vpc_id`, `create_rt`, `create_vpn`, `create_dx` and `create_ram`. Variables of resources disabled via the `count` variables will then be optional.
  */


# -------- AWS Transit Gateway ------------#


resource "aws_ec2_transit_gateway" "main_tgw" {
  count                           = var.create_transit_gateway ? 1 : 0
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Transit Gateway")}-${lookup(var.region_short_form, "us-east-1")}"
  })
}

# ----- Transit Gateway VPC Attachement --------

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc_attachement" {
  count                                           = length(var.vpc_id)
  vpc_id                                          = var.vpc_id[count.index][0]
  subnet_ids                                      = slice(reverse(var.subnet_id[count.index]), 0, 2)
  transit_gateway_id                              = var.create_transit_gateway ? aws_ec2_transit_gateway.main_tgw[0].id : var.transit_gateway_id
  appliance_mode_support                          = var.appliance_mode_support
  dns_support                                     = var.vpc_attachment_dns_support
  ipv6_support                                    = var.vpc_attachment_ipv6_support
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Transit Gateway")}-attach-${element(var.tgw_attachment_names, count.index)}-${lookup(var.region_short_form, "us-east-1")}"
  })
}


# ---------- Transit Gateway Route Table -------------

resource "aws_ec2_transit_gateway_route_table" "transitGatewayRoutetable" {
  count              = var.create_rt ? length(var.tgw_rt_tables) : 0
  transit_gateway_id =  try(aws_ec2_transit_gateway.main_tgw[0].id, var.transit_gateway_id)
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Transit Gateway route table")}-${element(var.tgw_rt_tables, count.index)}-${lookup(var.region_short_form, "us-east-1")}"
  })
}



# ----------- VPN Attachement ----------------

resource "aws_vpn_connection" "transitVpnAttachement" {
  count               = var.create_vpn ? length(var.vpn_ips) : 0
  transit_gateway_id  = try(aws_ec2_transit_gateway.main_tgw[0].id, var.transit_gateway_id)
  customer_gateway_id = try(var.customer_gateway_id)
  static_routes_only  = var.static_route_enable
  type                = var.vpn_type
  tags = merge(var.tags_for_all, {
    Name      = "${lookup(var.resource_short_form, "Vpn connection")}-${var.account_name}-${lookup(var.region_short_form, "us-east-1")}-01"
  })
}


# -------------- Direct Transit Gateway Association  --------------

resource "aws_dx_gateway_association" "dx_gateway_association" {
  count                 = var.create_dx ? 1 : 0
  dx_gateway_id         = try(var.dx_gateway_id, "")
  associated_gateway_id = try(aws_ec2_transit_gateway.main_tgw[0].id, var.transit_gateway_id)
  allowed_prefixes      = var.allowed_prefixes
}

# -------------- RAM Resources  --------------

resource "aws_ram_resource_share" "ram" {
  count                     = var.create_ram ? 1 : 0
  name                      = var.ram_name
  allow_external_principals = var.allow_external_principals

}

# -------------- Associate required resources --------------

resource "aws_ram_resource_association" "ram_resource_associate" {
  count              = var.create_ram ? 1 : 0
  resource_arn       = try(aws_ec2_transit_gateway.main_tgw[0].arn, var.transit_gateway_id)
  resource_share_arn = aws_ram_resource_share.ram.*.arn[0]
}

# -------------- Associate required principal --------------

resource "aws_ram_principal_association" "ram_principal_associate" {
  count              = var.create_ram && length(var.ram_principals) > 0 ? length(var.ram_principals) : 0
  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.ram.*.arn[0]
}