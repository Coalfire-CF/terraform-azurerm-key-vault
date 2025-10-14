![Coalfire](../../coalfire_logo.png)

## Description

This submodule creates and manages Azure Key Vault cryptographic keys with support for RSA and Elliptic Curve (EC) keys, including HSM-backed variants for enhanced security requirements.

Learn more at [Coalfire OpenSource](https://coalfire.com/opensource).

## Resource List

- Azure Key Vault Key
- Key Rotation Policy

## Features

- **Multiple Key Types**: Support for RSA, RSA-HSM, EC, and EC-HSM keys
- **FedRAMP Compliance**: Defaults to 4096-bit RSA keys with automatic rotation
- **Automatic Key Rotation**: Built-in rotation policies with configurable expiration and notification
- **Cryptographic Flexibility**: Configurable key operations (encrypt, decrypt, sign, verify, wrap, unwrap)
- **Comprehensive Outputs**: Key IDs, versions, and public key formats
- **HSM Support**: Hardware Security Module-backed keys for FedRAMP High requirements
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
  key_type     = "RSA-HSM"
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_key.key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_curve"></a> [curve](#input\_curve) | Elliptic curve name for EC keys (P-256, P-384, P-521). FedRAMP requires P-256 or higher | `string` | `"P-256"` | no |
| <a name="input_expiration_date"></a> [expiration\_date](#input\_expiration\_date) | Expiration date of the key in RFC3339 format. FedRAMP requires key rotation | `string` | `null` | no |
| <a name="input_key_opts"></a> [key\_opts](#input\_key\_opts) | List of key operations | `list(string)` | <pre>[<br/>  "decrypt",<br/>  "encrypt",<br/>  "sign",<br/>  "unwrapKey",<br/>  "verify",<br/>  "wrapKey"<br/>]</pre> | no |
| <a name="input_key_size"></a> [key\_size](#input\_key\_size) | Size of the RSA key (2048, 3072, or 4096). FedRAMP requires minimum 2048 | `number` | `4096` | no |
| <a name="input_key_type"></a> [key\_type](#input\_key\_type) | Type of key (RSA or EC). FedRAMP requires RSA-2048 or higher, or EC P-256 or higher | `string` | `"RSA"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The ID of the Key Vault where the key will be created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Key Vault key | `string` | n/a | yes |
| <a name="input_rotation_expire_after"></a> [rotation\_expire\_after](#input\_rotation\_expire\_after) | Time after creation when the key expires. | `string` | `"P90D"` | no |
| <a name="input_rotation_notify_before_expiry"></a> [rotation\_notify\_before\_expiry](#input\_rotation\_notify\_before\_expiry) | Time before expiry to send notification | `string` | `"P29D"` | no |
| <a name="input_rotation_policy_enabled"></a> [rotation\_policy\_enabled](#input\_rotation\_policy\_enabled) | Enable automatic key rotation policy | `bool` | `true` | no |
| <a name="input_rotation_time_before_expiry"></a> [rotation\_time\_before\_expiry](#input\_rotation\_time\_before\_expiry) | Time before expiry to automatically rotate the key | `string` | `"P30D"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the key | `map(string)` | <pre>{<br/>  "Compliance": "FedRAMP",<br/>  "ManagedBy": "Terraform"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | The ID of the Key Vault key |
| <a name="output_key_resource_id"></a> [key\_resource\_id](#output\_key\_resource\_id) | The resource ID of the Key Vault key |
| <a name="output_key_version"></a> [key\_version](#output\_key\_version) | The current version of the Key Vault key |
| <a name="output_key_versionless_id"></a> [key\_versionless\_id](#output\_key\_versionless\_id) | The versionless ID of the Key Vault key |
| <a name="output_public_key_openssh"></a> [public\_key\_openssh](#output\_public\_key\_openssh) | The public key in OpenSSH format |
| <a name="output_public_key_pem"></a> [public\_key\_pem](#output\_public\_key\_pem) | The public key in PEM format |
<!-- END_TF_DOCS -->

## Contributing

[Start Here](../../CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.