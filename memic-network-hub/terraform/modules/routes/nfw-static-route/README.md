<!-- BEGIN_TF_DOCS -->
# NFW-Static-Route Module

This is the readme of the aws nfw static route module. This module is used to do static routes for the nfw by providing its `vpc_endpoint_id`, `destination_cidr_block` and `route_table_id`.

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
| [aws_route.nfw-route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_cidr_block"></a> [destination\_cidr\_block](#input\_destination\_cidr\_block) | Destination CIDR block for NFW route table | `string` | n/a | yes |
| <a name="input_nfw_endpoint_id"></a> [nfw\_endpoint\_id](#input\_nfw\_endpoint\_id) | Network Firewall Endpoint id for route table | `string` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | The NFW route table id for aws route | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->