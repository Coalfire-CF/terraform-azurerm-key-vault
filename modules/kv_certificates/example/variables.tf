# Azure Key Vault Information
variable "key_vault_name" {
  description = "Name of the existing Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group containing the Key Vault"
  type        = string
}

# Certificate Configuration
variable "certificate_name" {
  description = "Name for the test certificate"
  type        = string
  default     = "test-self-signed-cert"
}

variable "test_domain" {
  description = "Domain name for the certificate (can be fake for testing)"
  type        = string
  default     = "test.example.com"
}

variable "subject_alternative_names" {
  description = "List of Subject Alternative Names (SANs) for the certificate"
  type        = list(string)
  default     = ["test.example.com", "api.test.example.com"]
}

# Certificate Subject Information
variable "organization_name" {
  description = "Organization name for certificate subject"
  type        = string
  default     = "Test Organization"
}

variable "organizational_unit" {
  description = "Organizational unit for certificate subject"
  type        = string
  default     = "IT Department"
}

variable "locality" {
  description = "Locality (city) for certificate subject"
  type        = string
  default     = "Test City"
}

variable "state" {
  description = "State or province for certificate subject"
  type        = string
  default     = "Test State"
}

variable "country" {
  description = "Country code for certificate subject"
  type        = string
  default     = "US"
}

# Certificate Options
variable "enable_auto_renewal" {
  description = "Enable automatic certificate renewal"
  type        = bool
  default     = true
}

# Tagging
variable "global_tags" {
  description = "Global level tags"
  type        = map(string)
  default = {
    Environment = "Sandbox"
    Project     = "KV-Certificates-Test"
  }
}

variable "regional_tags" {
  description = "Regional level tags"
  type        = map(string)
  default = {
    Region = "USGov-Virginia"
  }
}
