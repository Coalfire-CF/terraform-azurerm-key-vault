mock_provider "azurerm" {}

variables {
  name         = "k"
  key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-kv-1"
}

run "hsm_defaults" {
  command = plan

  module {
    source = "./modules/kv_key"
  }

  assert {
    condition     = azurerm_key_vault_key.key.key_type == "RSA-HSM"
    error_message = "key_type must default to RSA-HSM."
  }
  assert {
    condition     = azurerm_key_vault_key.key.key_size == 4096
    error_message = "key_size must default to 4096."
  }
  assert {
    condition     = length(azurerm_key_vault_key.key.rotation_policy) == 1
    error_message = "A rotation policy must be set by default."
  }
  assert {
    condition     = azurerm_key_vault_key.key.rotation_policy[0].expire_after == "P90D"
    error_message = "Keys must expire after 90 days by default."
  }
  assert {
    condition     = azurerm_key_vault_key.key.rotation_policy[0].automatic[0].time_before_expiry == "P30D"
    error_message = "Keys must auto-rotate 30 days before expiry by default."
  }
}

run "rejects_small_key" {
  command = plan

  module {
    source = "./modules/kv_key"
  }

  variables {
    key_size = 1024
  }

  expect_failures = [var.key_size]
}
