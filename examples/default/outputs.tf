output "key_vault_id" {
  description = "ID of the Key Vault."
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault."
  value       = module.key_vault.key_vault_uri
}

output "key_id" {
  description = "ID of the example key."
  value       = module.key.key_id
}

output "certificate_id" {
  description = "ID of the example certificate."
  value       = module.certificate.certificate_id
}
