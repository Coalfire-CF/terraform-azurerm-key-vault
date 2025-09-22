# Certificate Information
output "certificate_id" {
  description = "The ID of the created certificate"
  value       = module.test_self_signed_cert.certificate_id
}

output "certificate_name" {
  description = "The name of the created certificate"
  value       = module.test_self_signed_cert.certificate_name
}

output "certificate_version" {
  description = "The version of the created certificate"
  value       = module.test_self_signed_cert.certificate_version
}

output "certificate_thumbprint" {
  description = "The thumbprint of the created certificate"
  value       = module.test_self_signed_cert.certificate_thumbprint
}

output "certificate_secret_id" {
  description = "The secret ID for accessing the certificate"
  value       = module.test_self_signed_cert.certificate_secret_id
  sensitive   = true
}

output "certificate_versionless_id" {
  description = "The versionless ID of the certificate"
  value       = module.test_self_signed_cert.certificate_versionless_id
}

output "certificate_subject" {
  description = "The subject of the certificate"
  value       = module.test_self_signed_cert.certificate_subject
}

output "certificate_sans" {
  description = "The Subject Alternative Names of the certificate"
  value       = module.test_self_signed_cert.certificate_sans
}

output "certificate_attributes" {
  description = "Certificate attributes (created, expires, etc.)"
  value       = module.test_self_signed_cert.certificate_attribute
}

output "key_vault_info" {
  description = "Information about the Key Vault used"
  value = {
    key_vault_id   = data.azurerm_key_vault.existing.id
    key_vault_name = data.azurerm_key_vault.existing.name
    key_vault_uri  = data.azurerm_key_vault.existing.vault_uri
  }
}

# Policy Information
output "certificate_policy_info" {
  description = "Certificate policy details"
  value = {
    issuer_name   = module.test_self_signed_cert.certificate_policy_issuer_name
    key_properties = module.test_self_signed_cert.certificate_policy_key_properties
  }
}
