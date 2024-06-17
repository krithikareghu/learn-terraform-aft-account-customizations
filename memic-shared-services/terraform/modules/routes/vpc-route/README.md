<!-- BEGIN_TF_DOCS -->
# VPC-Route Module

This is the readme of the aws vpc route module. This module is used to attach transit gateway with vpc route table by providing the `transit_gateway_id` and vpc's `route_table_id`.

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
| [aws_route.tgw_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_cidr_block"></a> [destination\_cidr\_block](#input\_destination\_cidr\_block) | Destination CIDR block for VPC route table | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | The list of vpc route table ids for aws route | `string` | `""` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | Transit gateway id for VPC route table | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->