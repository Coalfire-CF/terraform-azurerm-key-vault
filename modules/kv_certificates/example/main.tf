terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  environment = "usgovernment"
}

# Data source to get existing Key Vault
data "azurerm_key_vault" "existing" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

# Self-signed certificate test
module "test_self_signed_cert" {
  source = "../"

  certificate_name = var.certificate_name
  key_vault_id     = data.azurerm_key_vault.existing.id
  certificate_type = "generate"

  # Required subject components 
  subject_common_name         = var.test_domain
  subject_organization        = var.organization_name
  subject_organizational_unit = var.organizational_unit
  subject_locality           = var.locality
  subject_state              = var.state
  subject_country            = var.country

  enable_auto_renewal = var.enable_auto_renewal

  # Testing with FedRAMP defaults (4096-bit RSA)
  certificate_policy = {
    issuer_name        = "Self"
    exportable         = true
    key_size           = 4096
    key_type           = "RSA"
    reuse_key          = false
    validity_in_months = 12
    subject_alternative_names = {
      dns_names = var.subject_alternative_names
    }
    lifetime_action = {
      action_type        = "AutoRenew"
      days_before_expiry = 30
    }
  }

  global_tags   = var.global_tags
  regional_tags = var.regional_tags
  tags = {
    Environment = "Test"
    Purpose     = "Module Testing"
    Certificate = "Self-Signed"
  }
}
