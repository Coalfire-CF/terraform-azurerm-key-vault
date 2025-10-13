resource "azurerm_key_vault_key" "key" {
  name         = var.name
  key_vault_id = var.key_vault_id
  key_type     = var.key_type
  key_size     = var.key_type == "RSA" || var.key_type == "RSA-HSM" ? var.key_size : null
  curve        = var.key_type == "EC" || var.key_type == "EC-HSM" ? var.curve : null
  key_opts     = var.key_opts

  expiration_date = var.expiration_date

  dynamic "rotation_policy" {
    for_each = var.rotation_policy_enabled ? [1] : []
    content {
      automatic {
        time_before_expiry = var.rotation_time_before_expiry
      }

      expire_after         = var.rotation_expire_after
      notify_before_expiry = var.rotation_notify_before_expiry
    }
  }

  tags = var.tags
}




