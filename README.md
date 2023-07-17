# Azure Key Vault

Azure Key Vault Module

## Description

Module creates an Azure Key Vault and configures diagnostic settings to send logs to a Log Analytics Workspace.

## Resource List

- Key Vault
- Diagnostic settings

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| kv_name | The Key Vault name | string | N/A | yes |
| location | The Azure location/region to create resources in | string | N/A | yes |
| resource_group_name | Azure Resource Group resource will be deployed in | string | N/A | yes |
| diag_log_analytics_id | ID of the Log Analytics Workspace diagnostic logs should be sent to | string | N/A | yes |
| tenant_id | The Azure tenant id | string | N/A | yes |
| enabled_for_deployment | Allows Azure VM's to retrieve secrets | bool | N/A | yes |
| enabled_for_disk_encryption | Azure Disk Encryption to retrieve secrets | bool | N/A | yes |
| tags | Resource level tags | map(string) | N/A | yes |
| regional_tags | Regional level tags | map(string) | N/A | yes |
| global_tags | Global level tags | map(string) | N/A | yes |
| enabled_for_template_deployment | Allow ARM to retrieve secrets | bool | true | no |
| network_acls | Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See <https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass> for more information | object | null | no |

## Outputs

| Name | Description |
|------|-------------|
| key_vault_id | The ID of the Key Vault |
| key_vault_name | Name of the Key Vault |
| key_vault_uri | The URI of the Key Vault |

## Usage

```hcl
module "ad_kv" {
  source = "../../../../modules/coalfire-az-key-vault"

  kv_name                         = "${local.resource_prefix}-ad-kv"
  resource_group_name             = data.terraform_remote_state.setup.outputs.key_vault_rg_name
  tenant_id                       = var.tenant_id
  enabled_for_disk_encryption     = false
  enabled_for_deployment          = false
  enabled_for_template_deployment = true
  regional_tags                   = var.regional_tags
  global_tags                     = var.global_tags
  diag_log_analytics_id           = data.terraform_remote_state.core.outputs.core_la_id
  tags = {
    Plane = "Management"
  }
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    virtual_network_subnet_ids = concat(
      values(data.terraform_remote_state.usgv_mgmt_vnet.outputs.usgv_mgmt_vnet_subnet_ids),
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diag"></a> [diag](#module\_diag) | github.com/Coalfire-CF/Ace-Azure-Diagnostics | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.key-vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [random_integer.kvid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diag_log_analytics_id"></a> [diag\_log\_analytics\_id](#input\_diag\_log\_analytics\_id) | ID of the Log Analytics Workspace diagnostic logs should be sent to | `string` | n/a | yes |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Allows Azure VM's to retreive secrets | `bool` | n/a | yes |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Azure Disk Encryption to retrieve secrets | `bool` | n/a | yes |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Allow ARM to retrieve secrets | `bool` | `true` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Global level tags | `map(string)` | n/a | yes |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | Key Vault Name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure location/region to create resources in. | `string` | n/a | yes |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations. | <pre>object({<br>    bypass                     = string,<br>    default_action             = string,<br>    ip_rules                   = list(string),<br>    virtual_network_subnet_ids = list(string),<br>  })</pre> | `null` | no |
| <a name="input_regional_tags"></a> [regional\_tags](#input\_regional\_tags) | Regional level tags | `map(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Azure Region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource level tags | `map(string)` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | Id of the Key Vault |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Name of the Key Vault |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | URI of the Key Vault |
<!-- END_TF_DOCS -->