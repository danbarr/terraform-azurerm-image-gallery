# Terraform module for an Azure compute gallery

This module creates an Azure compute gallery optionally seeded with image definitions.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.11.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_shared_image.packer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image) | resource |
| [azurerm_shared_image_gallery.packer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery) | resource |
| [azurerm_resource_group.packer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_publisher"></a> [publisher](#input\_publisher) | Publisher name to use on image definitions. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the existing resource group where the gallery will be created. | `string` | n/a | yes |
| <a name="input_image_definitions"></a> [image\_definitions](#input\_image\_definitions) | VM image definitions to create in the gallery. | <pre>list(object({<br>    name                    = string<br>    os_type                 = string<br>    offer                   = string<br>    sku                     = string<br>    app                     = string<br>    generation              = optional(string, "V2")<br>    trusted_launch_enabled  = optional(bool, true)<br>    confidential_vm_enabled = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_image_gallery_description"></a> [image\_gallery\_description](#input\_image\_gallery\_description) | Description for the shared image gallery. | `string` | `"Shared images built by Packer."` | no |
| <a name="input_image_gallery_name"></a> [image\_gallery\_name](#input\_image\_gallery\_name) | Name for the shared image gallery. | `string` | `"packer_images"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image_gallery_id"></a> [image\_gallery\_id](#output\_image\_gallery\_id) | ID of the created image gallery. |
| <a name="output_image_gallery_unique_name"></a> [image\_gallery\_unique\_name](#output\_image\_gallery\_unique\_name) | Unique name of the created image gallery. |
| <a name="output_shared_images"></a> [shared\_images](#output\_shared\_images) | Shared image definitions. |
<!-- END_TF_DOCS -->