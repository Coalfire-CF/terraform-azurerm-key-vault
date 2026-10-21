variable "kv_name" {
  description = "Key Vault name prefix, 3 to 21 characters."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group for the vault and private endpoint."
  type        = string
}

variable "location" {
  description = "Azure Government region, for example usgovvirginia."
  type        = string
}

variable "diag_log_analytics_id" {
  description = "Log Analytics workspace ID for vault diagnostics."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the vault's private endpoint."
  type        = string
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs for privatelink.vaultcore.usgovcloudapi.net."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}

variable "subject_common_name" {
  description = "Certificate subject common name."
  type        = string
  default     = "example.com"
}

variable "subject_organization" {
  description = "Certificate subject organization."
  type        = string
  default     = "Example"
}

variable "subject_organizational_unit" {
  description = "Certificate subject organizational unit."
  type        = string
  default     = "IT"
}

variable "subject_locality" {
  description = "Certificate subject locality."
  type        = string
  default     = "Example"
}

variable "subject_state" {
  description = "Certificate subject state."
  type        = string
  default     = "Example"
}

variable "subject_country" {
  description = "Certificate subject two-letter country code."
  type        = string
  default     = "US"
}
