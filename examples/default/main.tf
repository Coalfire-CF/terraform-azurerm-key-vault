terraform {
  required_version = ">= 1.16.6, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.10"
    }
  }
}

provider "azurerm" {
  features {}
  environment                     = "usgovernment"
  resource_provider_registrations = "none"
  resource_providers_to_register  = ["Microsoft.KeyVault", "Microsoft.Insights", "Microsoft.Network"]
}

data "azurerm_client_config" "current" {}

# Public network access is off and the firewall denies by default. The runner
# that applies this example must reach the vault through the private endpoint,
# or the key and certificate data-plane calls fail.
module "key_vault" {
  source = "../.."

  kv_name                    = var.kv_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  diag_log_analytics_id      = var.diag_log_analytics_id
  private_endpoint_subnet_id = var.private_endpoint_subnet_id
  private_dns_zone_ids       = var.private_dns_zone_ids

  tags          = var.tags
  global_tags   = {}
  regional_tags = {}
}

resource "azurerm_role_assignment" "crypto_officer" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "certificates_officer" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

module "key" {
  source = "../../modules/kv_key"

  name         = "example-cmk"
  key_vault_id = module.key_vault.key_vault_id
  tags         = var.tags

  depends_on = [azurerm_role_assignment.crypto_officer]
}

module "certificate" {
  source = "../../modules/kv_certificates"

  certificate_name            = "example-cert"
  key_vault_id                = module.key_vault.key_vault_id
  subject_common_name         = var.subject_common_name
  subject_organization        = var.subject_organization
  subject_organizational_unit = var.subject_organizational_unit
  subject_locality            = var.subject_locality
  subject_state               = var.subject_state
  subject_country             = var.subject_country
  tags                        = var.tags

  depends_on = [azurerm_role_assignment.certificates_officer]
}
