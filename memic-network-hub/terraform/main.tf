# ------- VPC  ---------

module "vpc" {
  source = "./modules/vpc"

  resource_short_form = var.resource_short_form
  region_short_form   = var.region_short_form

  count = length(var.vpc_prop)

  vpc_name                  = try(var.vpc_prop[count.index]["vpc_name"])
  account_number            = try(var.vpc_prop[count.index]["account_number"])
  vpc_cidr                  = try(var.vpc_prop[count.index]["vpc_cidr"])
  region_azs                = try(var.vpc_prop[count.index]["region_azs"])
  private_cidr              = try(var.vpc_prop[count.index]["private_cidr"])
  public_cidr               = try(var.vpc_prop[count.index]["public_cidr"])
  public_subnet_names       = try(var.vpc_prop[count.index]["public_subnet_names"])
  private_subnet_names      = try(var.vpc_prop[count.index]["private_subnet_names"])
  public_route_table_names  = try(var.vpc_prop[count.index]["public_route_table_names"])
  private_route_table_names = try(var.vpc_prop[count.index]["private_route_table_names"])

  enable_nat_gateway       = coalesce(var.vpc_prop[count.index]["enable_nat_gateway"], var.enable_nat_gateway)
  enable_igw               = coalesce(var.vpc_prop[count.index]["enable_igw"], var.enable_igw)
  enable_vpc_flow_log      = coalesce(var.vpc_prop[count.index]["enable_vpc_flow_log"], var.enable_vpc_flow_log)
  traffic_type             = coalesce(var.vpc_prop[count.index]["traffic_type"], var.traffic_type)
  log_destination_type     = coalesce(var.vpc_prop[count.index]["log_destination_type"], var.log_destination_type)
  vpc_flow_log_destination = try(var.vpc_prop[count.index]["vpc_flow_log_destination"], var.vpc_flow_log_destination)

  create_vpc_endpoint       = coalesce(var.vpc_prop[count.index]["create_vpc_endpoint"], var.create_vpc_endpoint)
  vpc_endpoint_type         = coalesce(var.vpc_prop[count.index]["vpc_endpoint_type"], var.vpc_endpoint_type)
  vpc_endpoint_service_name = coalesce(var.vpc_prop[count.index]["vpc_endpoint_service_name"], var.vpc_endpoint_service_name)
  tags_for_all              = var.tags
  domain_name = var.domain_name
  create_dhcpoption_set = var.create_dhcpoption_set
  create_dhcpoption_association = var.create_dhcpoption_association

}

# ------- Transit Gateway  ---------
module "tgw" {
  source                         = "./modules/tgw"
  resource_short_form            = var.resource_short_form
  region_short_form              = var.region_short_form
  create_transit_gateway         = var.create_transit_gateway
  auto_accept_shared_attachments = var.auto_accept_shared_attachments
  tgw_attachment_names       = var.tgw_attachment_names
  vpc_names                  = tolist(var.vpc_prop.*.vpc_name)
  vpc_id                     = module.vpc.*.vpc_id
  subnet_id                  = tolist(module.vpc.*.private_subnet_ids)
  appliance_mode_support     = var.appliance_mode_support
  vpc_attachment_dns_support = var.vpc_attachment_dns_support
  transit_gateway_id = var.transit_gateway_id
  create_rt          = var.create_rt
  tgw_rt_tables      = var.tgw_rt_tables
  create_ram                = var.create_ram
  ram_name                  = var.ram_name
  allow_external_principals = var.allow_external_principals
  ram_principals            = var.ram_principals
  resource_share_arn        = var.resource_share_arn
  share_tgw                 = var.share_tgw
  tags_for_all              = var.tags
}

# ------- Transit Gateway Association and Propagation  ---------
module "tgw-associate-propogate" {
  source = "./modules/tgw-asso-prop"
  count  = var.create_rt ? length(var.tgw_rt_tables) : 0
  tgw_associations        = lookup(var.tgw_associations, element(var.tgw_rt_tables, count.index))
  tgw_propogations        = lookup(var.tgw_propogations, element(var.tgw_rt_tables, count.index))
  # tgw_route_table_id      = element(var.tgw_route_table_id_ass_prop, count.index)
  active_static_routes    = lookup(var.active_static_routes, element(var.tgw_rt_tables, count.index))
  blackhole_static_routes = lookup(var.blackhole_static_routes, element(var.tgw_rt_tables, count.index))
  tgw_route_table_id   = module.tgw.transit_gateway_route_table_id[count.index]
  vpc_id               = module.vpc.*.vpc_id
  tgw_attachment_names = var.tgw_attachment_names
  subnet_id            = tolist(module.vpc.*.private_subnet_ids)
  transit_gateway_id   = module.tgw.transit_gateway_id[0]
}

# ------- VPC Routes  ---------
module "routes" {
  source = "./modules/routes/vpc-route"
  count = length(flatten([
    module.vpc[*].private_route_table_ids
  ]))

  route_table_id = flatten([
    module.vpc[*].private_route_table_ids
  ])[count.index]
  destination_cidr_block = var.vpc_tgw_routes[0]
  transit_gateway_id     = var.create_transit_gateway ? module.tgw.transit_gateway_id[0] : var.transit_gateway_id
}

