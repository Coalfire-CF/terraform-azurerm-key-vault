variable "kv_name" {
  description = "Key Vault Name"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,21}$", var.kv_name))
    error_message = "Kv_name may only contain alphanumeric characters and dashes and must be between 3-24 chars."
  }
}

variable "resource_group_name" {
  description = "Resource Group of Key Vault"
  type        = string
}

variable "location" {
  description = "The Azure location/region to create resources in."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string

}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed (true) or disabled (false)."
  type        = bool
  default     = false
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for the Key Vault. Strongly recommended for production."
  type        = bool
  default     = true
}

variable "enable_rbac_authorization" {
  description = "Whether RBAC authorization is enabled for the Key Vault instead of access policies."
  type        = bool
  default     = true
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Allows Azure VM's to retrieve secrets"
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Azure Disk Encryption to retrieve secrets"
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow ARM to retrieve secrets"
  default     = true
}

variable "network_acls" {
  description = "Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations."
  default     = null

  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })
}

variable "global_tags" {
  type        = map(string)
  description = "Global level tags"
}

variable "regional_tags" {
  type        = map(string)
  description = "Regional level tags"
}

variable "tags" {
  type        = map(string)
  description = "Resource level tags"
}

variable "diag_log_analytics_id" {
  description = "ID of the Log Analytics Workspace diagnostic logs should be sent to"
  type        = string
}
