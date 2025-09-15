resource "random_integer" "kvid" {
  min = 1
  max = 99
}

resource "azurerm_key_vault" "key-vault" {
  name                            = "${var.kv_name}-${random_integer.kvid.result}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  tenant_id                       = var.tenant_id
  soft_delete_retention_days      = 7
  purge_protection_enabled        = true
  enable_rbac_authorization       = true
  sku_name                        = "standard"
  tags = merge({
    Function = "Secrets Management"
  }, var.tags, var.global_tags, var.regional_tags)
  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : tolist([var.network_acls])
    iterator = acl
    content {
      bypass                     = coalesce(acl.value.bypass, "None")
      default_action             = coalesce(acl.value.default_action, "Deny")
      ip_rules                   = acl.value.ip_rules
      virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids
    }
  }
}

module "diag" {
  source                = "git::https://github.com/Coalfire-CF/terraform-azurerm-diagnostics"
  diag_log_analytics_id = var.diag_log_analytics_id
  resource_id           = azurerm_key_vault.key-vault.id
  resource_type         = "kv"
}
