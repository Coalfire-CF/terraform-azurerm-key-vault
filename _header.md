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

# Key Vault with RBAC (recommeneded) 

```hcl
module "kv" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault?ref=X.X.X"

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
  rbac_authorization_enabled      = true ##default


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

# Key Vault with Azure Policy (specific use cases) 

```hcl
module "kv" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault?ref=X.X.X"

  kv_name                         = "${var.resource_prefix}-fw-kv"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  public_network_access_enabled   = var.kv_public_network_access_enabled
  diag_log_analytics_id           = var.diag_log_analytics_id
  rbac_authorization_enabled      = false

  regional_tags = var.regional_tags
  global_tags   = var.global_tags
  tags          = var.tags

  network_acls = {
    bypass                     = "AzureServices"
    default_action             = var.kms_key_vault_network_access == "Private" ? "Deny" : "Allow"
    virtual_network_subnet_ids = var.kms_key_vault_network_access == "Private" ? var.kv_subnet_ids : []
    ip_rules                   = var.cidrs_for_remote_access
  }

  access_policy = [
    ## Firewall Managed Identity Access to get certs
    {
      tenant_id               = var.tenant_id
      object_id               = azurerm_user_assigned_identity.firewall_mi.principal_id
      certificate_permissions = ["Get", "List", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers"]
      secret_permissions      = ["Get", "List"]
    },
    ## Entra Admin Group Access to be able to upload cert
    {
      tenant_id               = var.tenant_id
      object_id               = var.entra_administrators_group_object_id
      certificate_permissions = ["Get", "List", "Delete", "Create", "Import", "Update", "Recover", "Backup", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers"]
      secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
    }
  ]
}
```

