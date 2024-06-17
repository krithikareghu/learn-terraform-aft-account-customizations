<!-- BEGIN_TF_DOCS -->
# TGW-Static-Route Module

This is the readme of the aws tgw static route module. This module is used to do static routes for the tgw by providing its `transit_gateway_route_table_id` and `transit_gateway_attachment_id`.

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
| [aws_ec2_transit_gateway_route.tgw-static-route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blackhole"></a> [blackhole](#input\_blackhole) | Transit gateway attachment id for TGW route table | `list(any)` | `[]` | no |
| <a name="input_destination_cidr_block"></a> [destination\_cidr\_block](#input\_destination\_cidr\_block) | Destination CIDR block for TGW route table | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_transit_gateway_attachment_id"></a> [transit\_gateway\_attachment\_id](#input\_transit\_gateway\_attachment\_id) | Transit gateway attachment id for TGW route table | `list(any)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#input\_transit\_gateway\_route\_table\_id) | The list of TGW route table ids for aws route | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->