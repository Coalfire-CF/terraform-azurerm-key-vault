output "key_id" {
  description = "The ID of the Key Vault key"
  value       = azurerm_key_vault_key.this.id
}

output "key_version" {
  description = "The current version of the Key Vault key"
  value       = azurerm_key_vault_key.this.version
}

output "key_versionless_id" {
  description = "The versionless ID of the Key Vault key"
  value       = azurerm_key_vault_key.this.versionless_id
}
