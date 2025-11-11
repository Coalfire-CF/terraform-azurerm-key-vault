![Coalfire](coalfire_logo.png)

# terraform-azurerm-keyvault

## Description

Module creates an Azure Key Vault and configures diagnostic settings to send logs to a Log Analytics Workspace.

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Resource List

- Key Vault
- Diagnostic settings

## Deployment Steps

This module can be called as outlined below.

- Change directories to the `terraform-azurerm-key-vault` directory.
- From the `/terraform-azurerm-key-vault` directory run `terraform init`.
- Run `terraform plan` to review the resources being created.
- If everything looks correct in the plan output, run `terraform apply`.

## Usage

Include example for how to call the module below with generic variables

```hcl
provider "azurerm" {
  features {}
}

module "kv" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault"

  kv_name                         = "${local.resource_prefix}-graf-kv"
  resource_group_name             = data.terraform_remote_state.setup.outputs.key_vault_rg_name
  location                        = var.location
  tenant_id                       = var.tenant_id
  enabled_for_disk_encryption     = false
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  kv_sku                          = "premium"
  regional_tags                   = var.regional_tags
  global_tags                     = merge(var.global_tags, local.global_local_tags)
  diag_log_analytics_id           = data.terraform_remote_state.core.outputs.core_la_id
  tags = {
    Plane = "Management"
  }
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    virtual_network_subnet_ids = concat(
      values(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_subnet_ids),
      local.app_subnet_ids
    )
    ip_rules = var.cidrs_for_remote_access
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diag"></a> [diag](#module\_diag) | git::https://github.com/Coalfire-CF/terraform-azurerm-diagnostics | v1.1.4 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [random_integer.kvid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diag_log_analytics_id"></a> [diag\_log\_analytics\_id](#input\_diag\_log\_analytics\_id) | ID of the Log Analytics Workspace diagnostic logs should be sent to | `string` | n/a | yes |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Allows Azure VM's to retrieve secrets | `bool` | `true` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Azure Disk Encryption to retrieve secrets | `bool` | `true` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Allow ARM to retrieve secrets | `bool` | `true` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Global level tags | `map(string)` | n/a | yes |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | Key Vault Name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure location/region to create resources in. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations. | <pre>object({<br/>    bypass                     = string,<br/>    default_action             = string,<br/>    ip_rules                   = list(string),<br/>    virtual_network_subnet_ids = list(string),<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is allowed (true) or disabled (false). | `bool` | `true` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Whether purge protection is enabled for the Key Vault. Strongly recommended for production. | `bool` | `true` | no |
| <a name="input_rbac_authorization_enabled"></a> [rbac\_authorization\_enabled](#input\_rbac\_authorization\_enabled) | Whether RBAC authorization is enabled for the Key Vault instead of access policies. | `bool` | `true` | no |
| <a name="input_regional_tags"></a> [regional\_tags](#input\_regional\_tags) | Regional level tags | `map(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group of Key Vault | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | SKU for Key Vault | `string` | `"standard"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource level tags | `map(string)` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | Id of the Key Vault |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Name of the Key Vault |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | URI of the Key Vault |
<!-- END_TF_DOCS -->

## Contributing

[Start Here](CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
## Tree
```
.
|-- CHANGELOG.md
|-- CONTRIBUTING.md
|-- LICENSE
|-- License.md
|-- README.md
|-- SECURITY.md
|-- coalfire_logo.png
|-- main.tf
|-- modules
|   |-- kv_certificates
|   |   |-- README.md
|   |   |-- example
|   |   |   |-- main.tf
|   |   |   |-- outputs.tf
|   |   |   |-- terraform.tfvars
|   |   |   |-- variables.tf
|   |   |-- main.tf
|   |   |-- outputs.tf
|   |   |-- variables.tf
|   |   |-- versions.tf
|   |-- kv_key
|       |-- README.md
|       |-- main.tf
|       |-- outputs.tf
|       |-- variables.tf
|       |-- versions.tf
|-- outputs.tf
|-- release-please-config.json
|-- update-readme-tree.sh
|-- variables.tf
```
