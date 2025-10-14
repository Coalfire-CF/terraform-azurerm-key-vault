![Coalfire](../../coalfire_logo.png)

## Description

This submodule creates and manages Azure Key Vault cryptographic keys with support for RSA and Elliptic Curve (EC) keys, including HSM-backed variants for enhanced security requirements.

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Resource List

- Azure Key Vault Key
- Key Rotation Policy

## Features

- **Multiple Key Types**: Support for RSA, RSA-HSM, EC, and EC-HSM keys
- **FedRAMP Compliance**: Defaults to 2048-bit RSA keys with automatic rotation
- **Automatic Key Rotation**: Built-in rotation policies with configurable expiration and notification
- **Cryptographic Flexibility**: Configurable key operations (encrypt, decrypt, sign, verify, wrap, unwrap)
- **HSM Support**: Hardware Security Module-backed keys for FedRAMP High requirements
- **Comprehensive Outputs**: Key IDs, versions, and public key formats
- **Consistent Tagging**: Integration with compliance and management tags

## Deployment Steps

This submodule can be called as outlined below.

### Prerequisites

**Authentication Setup**

```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id-here"
```

You can find your subscription ID using:
```bash
az account show --query id -o tsv
```

### Deployment

- Change directories to your Terraform configuration directory.
- Include the module call in your Terraform configuration.
- Run `terraform init` to initialize the module.
- Run `terraform plan` to review the resources being created.
- If everything looks correct in the plan output, run `terraform apply`.

## Usage

### Basic RSA Key (FedRAMP Moderate)

```hcl
module "encryption_key" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault/modules/kv_key"

  name         = "my-encryption-key"
  key_vault_id = module.key_vault.key_vault_id
  key_type     = "RSA"
  key_size     = 4096

  tags = {
    Environment = "Production"
    Application = "MyApp"
  }
}
```

### HSM-Backed RSA Key (FedRAMP High)

```hcl
module "hsm_key" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault/modules/kv_key"

  name         = "fed-key"
  key_vault_id = module.key_vault.key_vault_id
  key_type     = "RSA"
  key_size     = 4096

  # Custom rotation policy
  rotation_policy_enabled    = true
  rotation_expire_after      = "P180D"  # 180 days
  rotation_time_before_expiry = "P30D"   # Rotate 30 days before expiry

  tags = {
    Environment = "Production"
    Compliance  = "FedRAMP-High"
    DataClass   = "Sensitive"
  }
}
```

### Elliptic Curve Key

```hcl
module "ec_key" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault/modules/kv_key"

  name         = "ec-signing-key"
  key_vault_id = module.key_vault.key_vault_id
  key_type     = "EC"
  curve        = "P-384"

  # Restrict operations to signing only
  key_opts = ["sign", "verify"]

  enable_auto_renewal = true

  tags = {
    Environment = "Production"
    Purpose     = "Digital-Signature"
  }
}
```

### Key with Custom Expiration

```hcl
module "temp_key" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault/modules/kv_key"

  name         = "temporary-key"
  key_vault_id = module.key_vault.key_vault_id
  key_type     = "RSA"
  key_size     = 3072

  # Set explicit expiration date
  expiration_date = "2026-12-31T23:59:59Z"

  # Disable automatic rotation (manual rotation required)
  rotation_policy_enabled = false

  tags = {
    Environment = "Development"
    Purpose     = "Testing"
  }
}
```

### Key with All Operations

```hcl
module "multipurpose_key" {
  source = "github.com/Coalfire-CF/terraform-azurerm-key-vault/modules/kv_key"

  name         = "multipurpose-key"
  key_vault_id = module.key_vault.key_vault_id
  key_type     = "RSA"
  key_size     = 4096

  # All supported operations
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  tags = {
    Environment = "Production"
    Purpose     = "Multi-Function"
  }
}
```

## FedRAMP Compliance Defaults

This module includes FedRAMP-compliant defaults:

- **Key Type**: RSA (software-protected)
- **Key Size**: 2048 bits minimum (RSA)
- **EC Curve**: P-256 minimum (Elliptic Curve)
- **Key Operations**: All operations enabled by default (encrypt, decrypt, sign, verify, wrap, unwrap)
- **Rotation Policy**: Enabled by default
- **Rotation Period**: 90 days
- **Rotation Advance Notice**: 30 days before expiration
- **Notification Period**: 30 days before expiration
- **Required Tags**: Compliance=FedRAMP, ManagedBy=Terraform

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