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
