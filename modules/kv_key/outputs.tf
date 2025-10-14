output "key_id" {
  description = "The ID of the Key Vault key"
  value       = azurerm_key_vault_key.key.id
}

output "key_name" {
  description = "The name of the Key Vault key"
  value       = azurerm_key_vault_key.key.name
}

output "key_version" {
  description = "The current version of the Key Vault key"
  value       = azurerm_key_vault_key.key.version
}

output "key_versionless_id" {
  description = "The versionless ID of the Key Vault key"
  value       = azurerm_key_vault_key.key.versionless_id
}

output "key_resource_id" {
  description = "The resource ID of the Key Vault key"
  value       = azurerm_key_vault_key.key.resource_id 
}

output "public_key_pem" {
  description = "The public key in PEM format"
  value       = azurerm_key_vault_key.key.public_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "The public key in OpenSSH format"
  value       = azurerm_key_vault_key.key.public_key_openssh
  sensitive   = true
}