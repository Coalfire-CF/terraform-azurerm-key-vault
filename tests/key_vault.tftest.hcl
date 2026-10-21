mock_provider "azurerm" {}

variables {
  kv_name               = "test-kv"
  resource_group_name   = "test-rg"
  location              = "usgovvirginia"
  tenant_id             = "00000000-0000-0000-0000-000000000000"
  diag_log_analytics_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.OperationalInsights/workspaces/test-law"
  tags                  = {}
  global_tags           = {}
  regional_tags         = {}
}

run "secure_defaults" {
  command = plan

  assert {
    condition     = azurerm_key_vault.key_vault.public_network_access_enabled == false
    error_message = "public_network_access_enabled must default to false."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.purge_protection_enabled == true
    error_message = "purge_protection_enabled must default to true."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.rbac_authorization_enabled == true
    error_message = "rbac_authorization_enabled must default to true."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.soft_delete_retention_days == 90
    error_message = "soft_delete_retention_days must default to 90."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.sku_name == "premium"
    error_message = "sku_name must default to premium."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.network_acls[0].default_action == "Deny"
    error_message = "network_acls default_action must default to Deny."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.network_acls[0].bypass == "None"
    error_message = "network_acls bypass must default to None."
  }
  assert {
    condition     = length(azurerm_key_vault.key_vault.network_acls[0].ip_rules) == 0
    error_message = "network_acls must allow no IPs by default."
  }
  assert {
    condition     = length(azurerm_key_vault.key_vault.network_acls[0].virtual_network_subnet_ids) == 0
    error_message = "network_acls must allow no subnets by default."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.tags["Function"] == "Secrets Management"
    error_message = "The module Function tag must be set."
  }
  assert {
    condition     = length(azurerm_private_endpoint.key_vault) == 0
    error_message = "No private endpoint without a subnet ID."
  }
}

run "null_network_acls_still_denies" {
  command = plan

  variables {
    network_acls = null
  }

  assert {
    condition     = azurerm_key_vault.key_vault.network_acls[0].default_action == "Deny"
    error_message = "A null network_acls must still deny."
  }
}

run "partial_network_acls" {
  command = plan

  variables {
    network_acls = {
      ip_rules = ["203.0.113.10"]
    }
  }

  assert {
    condition     = azurerm_key_vault.key_vault.network_acls[0].default_action == "Deny"
    error_message = "Omitted default_action must fall back to Deny."
  }
  assert {
    condition     = azurerm_key_vault.key_vault.network_acls[0].bypass == "None"
    error_message = "Omitted bypass must fall back to None."
  }
  assert {
    condition     = length(azurerm_key_vault.key_vault.network_acls[0].ip_rules) == 1
    error_message = "The caller's IP rule must be kept."
  }
}

run "private_endpoint" {
  command = plan

  variables {
    private_endpoint_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/pe"
    private_dns_zone_ids       = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.usgovcloudapi.net"]
  }

  assert {
    condition     = length(azurerm_private_endpoint.key_vault) == 1
    error_message = "A subnet ID must create one private endpoint."
  }
  assert {
    condition     = azurerm_private_endpoint.key_vault[0].private_service_connection[0].subresource_names == tolist(["vault"])
    error_message = "The private endpoint must target the vault subresource."
  }
  assert {
    condition     = azurerm_private_endpoint.key_vault[0].private_dns_zone_group[0].private_dns_zone_ids == var.private_dns_zone_ids
    error_message = "The private DNS zone IDs must be attached."
  }
  assert {
    condition     = azurerm_private_endpoint.key_vault[0].private_service_connection[0].is_manual_connection == false
    error_message = "The private endpoint connection must be automatic."
  }
}

run "accepts_max_retention" {
  command = plan

  variables {
    soft_delete_retention_days = 90
    kv_name                    = "abc"
  }

  assert {
    condition     = azurerm_key_vault.key_vault.soft_delete_retention_days == 90
    error_message = "90 days must be accepted."
  }
}

run "rejects_short_retention" {
  command = plan

  variables {
    soft_delete_retention_days = 6
  }

  expect_failures = [var.soft_delete_retention_days]
}

run "rejects_bad_default_action" {
  command = plan

  variables {
    network_acls = {
      default_action = "Open"
    }
  }

  expect_failures = [var.network_acls]
}

run "rejects_short_name" {
  command = plan

  variables {
    kv_name = "a"
  }

  expect_failures = [var.kv_name]
}
