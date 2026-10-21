mock_provider "azurerm" {}

variables {
  certificate_name            = "test-cert"
  key_vault_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-kv-1"
  subject_common_name         = "example.com"
  subject_organization        = "Example"
  subject_organizational_unit = "IT"
  subject_locality            = "Example"
  subject_state               = "Example"
  subject_country             = "US"
}

run "generate_defaults" {
  command = plan

  module {
    source = "./modules/kv_certificates"
  }

  assert {
    condition     = azurerm_key_vault_certificate.certificate.certificate_policy[0].key_properties[0].key_type == "RSA"
    error_message = "Generated certificates must default to RSA keys."
  }
  assert {
    condition     = azurerm_key_vault_certificate.certificate.certificate_policy[0].key_properties[0].key_size == 4096
    error_message = "Generated certificates must default to 4096-bit keys."
  }
  assert {
    condition     = azurerm_key_vault_certificate.certificate.certificate_policy[0].lifetime_action[0].action[0].action_type == "AutoRenew"
    error_message = "Generated certificates must auto-renew by default."
  }
  assert {
    condition     = azurerm_key_vault_certificate.certificate.certificate_policy[0].x509_certificate_properties[0].validity_in_months == 12
    error_message = "Generated certificates must default to 12 months validity."
  }
}
