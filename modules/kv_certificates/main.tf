locals {
  # Construct subject string from individual components
  subject_string = join(",", compact([
    "CN=${var.subject_common_name}",
    "OU=${var.subject_organizational_unit}",
    "O=${var.subject_organization}",
    "L=${var.subject_locality}",
    "ST=${var.subject_state}",
    "C=${var.subject_country}"
  ]))
}

resource "azurerm_key_vault_certificate" "certificate" {
  name         = var.certificate_name
  key_vault_id = var.key_vault_id
  tags         = merge(var.tags, var.regional_tags, var.global_tags)

  # Certificate policy for generating certificates (self-signed or CA-signed)
  dynamic "certificate_policy" {
    for_each = var.certificate_type == "generate" ? [1] : []
    content {
      issuer_parameters {
        name = var.certificate_policy != null ? var.certificate_policy.issuer_name : "Self"
      }

      key_properties {
        exportable = var.certificate_policy != null ? var.certificate_policy.exportable : true
        key_size   = var.certificate_policy != null ? var.certificate_policy.key_size : 4096
        key_type   = var.certificate_policy != null ? var.certificate_policy.key_type : "RSA"
        reuse_key  = var.certificate_policy != null ? var.certificate_policy.reuse_key : false
        curve      = var.certificate_policy != null ? var.certificate_policy.curve : null
      }

      dynamic "lifetime_action" {
        for_each = var.enable_auto_renewal ? [1] : []
        content {
          action {
            action_type = var.certificate_policy != null && var.certificate_policy.lifetime_action != null ? var.certificate_policy.lifetime_action.action_type : "AutoRenew"
          }

          trigger {
            days_before_expiry  = var.certificate_policy != null && var.certificate_policy.lifetime_action != null && var.certificate_policy.lifetime_action.days_before_expiry != null ? var.certificate_policy.lifetime_action.days_before_expiry : 30
            lifetime_percentage = var.certificate_policy != null && var.certificate_policy.lifetime_action != null ? var.certificate_policy.lifetime_action.lifetime_percentage : null
          }
        }
      }

      secret_properties {
        content_type = var.certificate_policy != null ? var.certificate_policy.content_type : "application/x-pkcs12"
      }

      x509_certificate_properties {
        extended_key_usage = var.certificate_policy != null ? var.certificate_policy.extended_key_usage : ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]
        key_usage          = var.certificate_policy != null ? var.certificate_policy.key_usage : ["digitalSignature", "keyEncipherment"]
        subject            = local.subject_string
        validity_in_months = var.certificate_policy != null ? var.certificate_policy.validity_in_months : 12

        dynamic "subject_alternative_names" {
          for_each = var.certificate_policy != null && var.certificate_policy.subject_alternative_names != null ? [var.certificate_policy.subject_alternative_names] : []
          content {
            dns_names = subject_alternative_names.value.dns_names
            emails    = subject_alternative_names.value.emails
            upns      = subject_alternative_names.value.upns
          }
        }
      }
    }
  }

  # For importing existing certificates
  dynamic "certificate" {
    for_each = var.certificate_type == "import" && var.certificate_contents != null ? [var.certificate_contents] : []
    content {
      contents = certificate.value.contents
      password = certificate.value.password
    }
  }
}
