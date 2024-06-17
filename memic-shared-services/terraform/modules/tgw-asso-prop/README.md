<!-- BEGIN_TF_DOCS -->
# TGW-ASSO-PROP Module

This is the readme of the aws transit gateway association and propagation module. This module can be used to create tgw route table association, propagation and tgw static routes.

The behaviour of the module can be changed by adjusting the value of `count` variables `tgw_associations`, `tgw_propagations`, `active_static_routes` and `blackhole_static_routes`. Variables of resources disabled via the `count` variables will then be optional.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.active_static_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.blackhole_static_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table_association.tgw_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.tgw_propagation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_static_routes"></a> [active\_static\_routes](#input\_active\_static\_routes) | Active Static routes in tgw route tables | `list(any)` | `[]` | no |
| <a name="input_blackhole_static_routes"></a> [blackhole\_static\_routes](#input\_blackhole\_static\_routes) | Blackhole Static routes in tgw route tables | `list(any)` | `[]` | no |
| <a name="input_create_static_rt"></a> [create\_static\_rt](#input\_create\_static\_rt) | To create static route in tgw route table | `bool` | `false` | no |
| <a name="input_tgw_associations"></a> [tgw\_associations](#input\_tgw\_associations) | Transit Gateway Associations for Route Table | `list(any)` | n/a | yes |
| <a name="input_tgw_propogations"></a> [tgw\_propogations](#input\_tgw\_propogations) | Transit Gateway Associations for Route Table | `list(any)` | n/a | yes |
| <a name="input_tgw_route_table_id"></a> [tgw\_route\_table\_id](#input\_tgw\_route\_table\_id) | Transit Gateway Route Table ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tgw_route_table_association_id"></a> [tgw\_route\_table\_association\_id](#output\_tgw\_route\_table\_association\_id) | The id of the associations created on the TGW route table |
| <a name="output_tgw_route_table_propagation_id"></a> [tgw\_route\_table\_propagation\_id](#output\_tgw\_route\_table\_propagation\_id) | The id of the propagations created on the TGW route table |
<!-- END_TF_DOCS -->