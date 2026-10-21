locals {
  tags = merge({
    Function = "Secrets Management"
  }, var.tags, var.global_tags, var.regional_tags)
}

resource "random_integer" "kvid" {
  min = 1
  max = 99
}

# tflint-ignore: azurerm_resources_missing_prevent_destroy # prevent_destroy cannot be set from an input; a module-wide value would block every caller's teardown. Purge protection and 90-day soft delete protect the vault.
resource "azurerm_key_vault" "key_vault" {
  name                            = "${var.kv_name}-${random_integer.kvid.result}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  tenant_id                       = var.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  rbac_authorization_enabled      = var.rbac_authorization_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  sku_name                        = var.sku_name
  tags                            = local.tags

  network_acls {
    bypass                     = var.network_acls.bypass
    default_action             = var.network_acls.default_action
    ip_rules                   = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }

  dynamic "access_policy" {
    for_each = var.access_policy
    content {
      tenant_id               = access_policy.value.tenant_id
      object_id               = access_policy.value.object_id
      application_id          = access_policy.value.application_id
      certificate_permissions = access_policy.value.certificate_permissions
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }
}

resource "azurerm_private_endpoint" "key_vault" {
  count               = var.private_endpoint_subnet_id != null ? 1 : 0
  name                = "${azurerm_key_vault.key_vault.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = local.tags

  private_service_connection {
    name                           = "${azurerm_key_vault.key_vault.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "${azurerm_key_vault.key_vault.name}-dnsgroup"
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }
}

module "diag" {
  source                = "git::https://github.com/Coalfire-CF/terraform-azurerm-diagnostics?ref=v3.0.0"
  diag_log_analytics_id = var.diag_log_analytics_id
  resource_id           = azurerm_key_vault.key_vault.id
  resource_type         = "kv"
}
