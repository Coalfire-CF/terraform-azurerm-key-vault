![Coalfire](coalfire_logo.png)

# terraform-azurerm-key-vault

## Description

Module creates an Azure Key Vault, an optional private endpoint, and diagnostic settings that send logs to a Log Analytics workspace.

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Resource List

- Key Vault
- Private endpoint (optional)
- Diagnostic settings

## Secure defaults

- Public network access is off.
- The vault firewall denies by default, with no allowed IPs or subnets and no trusted-service bypass.
- RBAC authorization is on.
- Purge protection is on.
- Soft delete keeps deleted objects for 90 days.
- The SKU is premium, so HSM-backed keys work.
- Diagnostics go through `terraform-azurerm-diagnostics` v3.0.0.
- `enabled_for_deployment`, `enabled_for_disk_encryption` and `enabled_for_template_deployment` default to true, but those platform paths only work through the firewall when `network_acls.bypass = "AzureServices"`.

Set `private_endpoint_subnet_id` and `private_dns_zone_ids` (zone `privatelink.vaultcore.usgovcloudapi.net`) to create the private endpoint. Without `private_endpoint_subnet_id` the module creates no endpoint, and the caller must create private access.

## Deployment Steps

See [examples/default](examples/default) for a complete root with a vault, a key and a certificate. The runner must reach the vault through its private endpoint.

## Usage

### Key Vault with RBAC (recommended)

```hcl
module "kv" {
  source = "git::https://github.com/Coalfire-CF/terraform-azurerm-key-vault?ref=v3.0.0"

  kv_name               = "${var.resource_prefix}-kv"
  resource_group_name   = var.resource_group_name
  location              = var.location
  tenant_id             = var.tenant_id
  sku_name              = "premium"
  diag_log_analytics_id = var.diag_log_analytics_id

  private_endpoint_subnet_id = var.private_endpoint_subnet_id
  private_dns_zone_ids       = var.private_dns_zone_ids

  network_acls = {
    virtual_network_subnet_ids = var.kv_subnet_ids
    ip_rules                   = var.cidrs_for_remote_access
  }

  regional_tags = var.regional_tags
  global_tags   = var.global_tags
  tags = {
    Plane = "Management"
  }
}
```

### Key Vault with access policies

Access policies cannot be scoped below the vault and are not governed by Entra PIM. Use them only where a consumer cannot use RBAC.

```hcl
module "kv" {
  source = "git::https://github.com/Coalfire-CF/terraform-azurerm-key-vault?ref=v3.0.0"

  kv_name                    = "${var.resource_prefix}-fw-kv"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  diag_log_analytics_id      = var.diag_log_analytics_id
  rbac_authorization_enabled = false

  private_endpoint_subnet_id = var.private_endpoint_subnet_id
  private_dns_zone_ids       = var.private_dns_zone_ids

  network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = var.kv_subnet_ids
    ip_rules                   = var.cidrs_for_remote_access
  }

  access_policy = [
    {
      tenant_id               = var.tenant_id
      object_id               = var.firewall_identity_principal_id
      certificate_permissions = ["Get", "List"]
      secret_permissions      = ["Get", "List"]
    }
  ]

  regional_tags = var.regional_tags
  global_tags   = var.global_tags
  tags          = var.tags
}
```

### Keys and certificates

Use the submodules with `source = "git::https://github.com/Coalfire-CF/terraform-azurerm-key-vault//modules/kv_key?ref=v3.0.0"` and `//modules/kv_certificates?ref=v3.0.0`. See [modules/kv_key](modules/kv_key/README.md) and [modules/kv_certificates](modules/kv_certificates/README.md).
