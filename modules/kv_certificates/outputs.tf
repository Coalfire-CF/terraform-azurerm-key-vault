output "certificate_id" {
  description = "The ID of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.id
}

output "certificate_name" {
  description = "The name of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.name
}

output "certificate_version" {
  description = "The current version of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.version
}

output "certificate_versionless_id" {
  description = "The versionless ID of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.versionless_id
}

output "certificate_versionless_secret_id" {
  description = "The versionless secret ID of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.versionless_secret_id
}

output "certificate_secret_id" {
  description = "The secret ID of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.secret_id
}

output "certificate_thumbprint" {
  description = "The X.509 thumbprint of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.thumbprint
}

output "certificate_data" {
  description = "The raw certificate data in PEM format"
  value       = azurerm_key_vault_certificate.certificate.certificate_data
  sensitive   = true
}

output "certificate_data_base64" {
  description = "The raw certificate data in base64 format"
  value       = azurerm_key_vault_certificate.certificate.certificate_data_base64
  sensitive   = true
}

output "resource_manager_id" {
  description = "The Azure Resource Manager ID of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.resource_manager_id
}

output "resource_manager_versionless_id" {
  description = "The Azure Resource Manager versionless ID of the Key Vault certificate"
  value       = azurerm_key_vault_certificate.certificate.resource_manager_versionless_id
}

output "certificate_attribute" {
  description = "The certificate attributes"
  value = {
    created     = azurerm_key_vault_certificate.certificate.certificate_attribute[0].created
    enabled     = azurerm_key_vault_certificate.certificate.certificate_attribute[0].enabled
    expires     = azurerm_key_vault_certificate.certificate.certificate_attribute[0].expires
    not_before  = azurerm_key_vault_certificate.certificate.certificate_attribute[0].not_before
    recovery_level = azurerm_key_vault_certificate.certificate.certificate_attribute[0].recovery_level
    updated     = azurerm_key_vault_certificate.certificate.certificate_attribute[0].updated
  }
}

output "certificate_policy_issuer_name" {
  description = "The issuer name of the certificate policy"
  value       = length(azurerm_key_vault_certificate.certificate.certificate_policy) > 0 ? azurerm_key_vault_certificate.certificate.certificate_policy[0].issuer_parameters[0].name : null
}

output "certificate_policy_key_properties" {
  description = "The key properties of the certificate policy"
  value = length(azurerm_key_vault_certificate.certificate.certificate_policy) > 0 ? {
    exportable = azurerm_key_vault_certificate.certificate.certificate_policy[0].key_properties[0].exportable
    key_size   = azurerm_key_vault_certificate.certificate.certificate_policy[0].key_properties[0].key_size
    key_type   = azurerm_key_vault_certificate.certificate.certificate_policy[0].key_properties[0].key_type
    reuse_key  = azurerm_key_vault_certificate.certificate.certificate_policy[0].key_properties[0].reuse_key
    curve      = azurerm_key_vault_certificate.certificate.certificate_policy[0].key_properties[0].curve
  } : null
}

output "certificate_subject" {
  description = "The subject of the certificate"
  value       = length(azurerm_key_vault_certificate.certificate.certificate_policy) > 0 ? azurerm_key_vault_certificate.certificate.certificate_policy[0].x509_certificate_properties[0].subject : null
}

output "certificate_sans" {
  description = "The Subject Alternative Names (SANs) of the certificate"
  value = length(azurerm_key_vault_certificate.certificate.certificate_policy) > 0 && length(azurerm_key_vault_certificate.certificate.certificate_policy[0].x509_certificate_properties[0].subject_alternative_names) > 0 ? {
    dns_names = azurerm_key_vault_certificate.certificate.certificate_policy[0].x509_certificate_properties[0].subject_alternative_names[0].dns_names
    emails    = azurerm_key_vault_certificate.certificate.certificate_policy[0].x509_certificate_properties[0].subject_alternative_names[0].emails
    upns      = azurerm_key_vault_certificate.certificate.certificate_policy[0].x509_certificate_properties[0].subject_alternative_names[0].upns
  } : null
}
