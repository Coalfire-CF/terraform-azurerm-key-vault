![Coalfire](../../coalfire_logo.png)

# Key Vault Certificates Submodule

## Description

This submodule creates and manages Azure Key Vault certificates with support for both generated certificates (self-signed or CA-signed) and imported certificates.

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Resource List

- Azure Key Vault Certificate
- Certificate Policy (for generated certificates)
- Certificate Contents (for imported certificates)

## Features

- **Dual Certificate Support**: Generate new certificates or import existing ones
- **FedRAMP Compliance**: Defaults to 4096-bit RSA keys and strong encryption standards
- **Required Subject Components**: Build certificate subjects from individual required components
- **Auto-Renewal Support**: Optional automatic certificate renewal before expiration
- **Comprehensive Outputs**: All certificate metadata, thumbprints, and attributes
- **Subject Alternative Names**: Support for DNS names, emails, and UPNs
- **Consistent Tagging**: Integration with global, regional, and resource-level tags

## Deployment Steps

This submodule can be called as outlined below.

- Change directories to your Terraform configuration directory.
- Include the module call in your Terraform configuration.
- Run `terraform init` to initialize the module.
- Run `terraform plan` to review the resources being created.
- If everything looks correct in the plan output, run `terraform apply`.

## Usage

### Generate a Self-Signed Certificate

```hcl
module "self_signed_cert" {
  source = "./modules/kv_certificates"

  certificate_name = "my-app-cert"
  key_vault_id     = module.key_vault.key_vault_id
  certificate_type = "generate"
  
  # Subject components (will be combined into subject string)
  subject_common_name         = "myapp.example.com"
  subject_organization        = "My Organization"
  subject_organizational_unit = "IT Department"
  subject_locality           = "Seattle"
  subject_state              = "WA"
  subject_country            = "US"

  enable_auto_renewal = true

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

### Generate a CA-Signed Certificate

```hcl
module "ca_signed_cert" {
  source = "./modules/kv_certificates"

  certificate_name = "ca-signed-cert"
  key_vault_id     = module.key_vault.key_vault_id
  certificate_type = "generate"

  # Required subject components
  subject_common_name         = "myapp.example.com"
  subject_organization        = "My Organization"
  subject_organizational_unit = "IT Department"
  subject_locality           = "Seattle"
  subject_state              = "WA"
  subject_country            = "US"

  certificate_policy = {
    issuer_name        = "DigiCert"  # Or your CA issuer
    validity_in_months = 24
    key_size          = 4096
    key_type          = "RSA"
    subject_alternative_names = {
      dns_names = ["myapp.example.com", "api.myapp.example.com"]
    }
  }

  enable_auto_renewal = true

  tags = {
    Environment = "Production"
    CertType   = "CA-Signed"
  }
}
```

### Import an Existing Certificate

```hcl
module "imported_cert" {
  source = "./modules/kv_certificates"

  certificate_name = "imported-cert"
  key_vault_id     = module.key_vault.key_vault_id
  certificate_type = "import"

  certificate_contents = {
    contents = file("path/to/certificate.pfx")
    password = var.cert_password
  }

  tags = {
    Environment = "Production"
    Source     = "External"
  }
}
```

## FedRAMP Compliance Defaults

This module includes FedRAMP-compliant defaults:

- **Key Size**: 4096 bits (RSA)
- **Key Type**: RSA
- **Key Usage**: Digital Signature, Key Encipherment
- **Extended Key Usage**: Server Authentication (1.3.6.1.5.5.7.3.1), Client Authentication (1.3.6.1.5.5.7.3.2)
- **Validity Period**: 12 months
- **Auto-Renewal**: 30 days before expiration
- **Country**: Required input (no default)

### Import Mode
- Imports existing certificates (PFX/P12 format)
- Preserves original certificate properties
- Password-protected certificates supported
- Useful for migrating certificates from other systems

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.2 |
| azurerm | >= 3.73 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.73 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_certificate.certificate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certificate_name | The name of the certificate | `string` | n/a | yes |
| key_vault_id | The ID of the Key Vault where the certificate will be stored | `string` | n/a | yes |
| certificate_type | Type of certificate to create: 'generate' or 'import' | `string` | `"generate"` | no |
| certificate_policy | Certificate policy configuration for generating certificates | `object` | `null` | no |
| certificate_contents | Certificate contents for importing existing certificates | `object` | `null` | no |
| enable_auto_renewal | Enable automatic certificate renewal | `bool` | `true` | no |
| subject_common_name | Common Name (CN) for the certificate subject | `string` | n/a | yes |
| subject_organization | Organization (O) for the certificate subject | `string` | n/a | yes |
| subject_organizational_unit | Organizational Unit (OU) for the certificate subject | `string` | n/a | yes |
| subject_country | Country (C) for the certificate subject | `string` | n/a | yes |
| subject_state | State or Province (ST) for the certificate subject | `string` | n/a | yes |
| subject_locality | Locality (L) for the certificate subject | `string` | n/a | yes |
| tags | Resource level tags | `map(string)` | `{}` | no |
| regional_tags | Regional level tags | `map(string)` | `{}` | no |
| global_tags | Global level tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| certificate_id | The ID of the Key Vault certificate |
| certificate_name | The name of the Key Vault certificate |
| certificate_version | The current version of the Key Vault certificate |
| certificate_versionless_id | The versionless ID of the Key Vault certificate |
| certificate_secret_id | The secret ID of the Key Vault certificate |
| certificate_thumbprint | The X.509 thumbprint of the Key Vault certificate |
| certificate_data | The raw certificate data in PEM format (sensitive) |
| certificate_attribute | The certificate attributes (created, expires, etc.) |
| certificate_subject | The subject of the certificate |
| certificate_sans | The Subject Alternative Names (SANs) of the certificate |
<!-- END_TF_DOCS -->

## Contributing

[Start Here](../../CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
