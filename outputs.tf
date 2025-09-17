
output "key_vault_id" {
  description = "Id of the Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.key_vault.vault_uri
}
