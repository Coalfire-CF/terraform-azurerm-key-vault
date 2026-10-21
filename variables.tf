variable "kv_name" {
  description = "Key Vault Name"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,21}$", var.kv_name))
    error_message = "kv_name must be 3 to 21 alphanumeric characters or dashes. The module appends -<1-99>, so the vault name is at most 24 characters."
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

variable "sku_name" {
  description = "Key Vault SKU. Defaults to premium so HSM-backed keys work. Standard vaults cannot hold HSM keys."
  type        = string
  default     = "premium"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be standard or premium."
  }
}

variable "public_network_access_enabled" {
  description = "Allow public network access to the vault. Defaults to false. Setting true exposes the data plane to public networks, limited only by network_acls; reach the vault through a private endpoint instead."
  type        = bool
  default     = false
}

variable "purge_protection_enabled" {
  description = "Purge protection. Defaults to true (baseline R16). Setting false lets a deleted vault and its keys be purged permanently before the retention period ends."
  type        = bool
  default     = true
}

variable "rbac_authorization_enabled" {
  description = "Use Azure RBAC for data-plane access. Defaults to true (baseline R16). Setting false uses access policies, which cannot be scoped below the vault and are not governed by Entra PIM."
  type        = bool
  default     = true
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Allows Azure VM's to retrieve secrets"
  default     = true
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Azure Disk Encryption to retrieve secrets"
  default     = true
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow ARM to retrieve secrets"
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Days a deleted vault and its objects stay recoverable. Defaults to 90 (baseline R16). Lower values shorten the recovery window."
  type        = number
  default     = 90
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "network_acls" {
  description = "Vault firewall. Defaults to deny with no allowed IPs or subnets and no trusted-service bypass. default_action = Allow opens the vault to every network that can reach it. Set bypass = AzureServices if enabled_for_deployment, enabled_for_disk_encryption or enabled_for_template_deployment must work while the firewall denies."
  type = object({
    bypass                     = optional(string, "None")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  nullable = false
  default = {
    bypass                     = "None"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  validation {
    condition     = contains(["Allow", "Deny"], var.network_acls.default_action)
    error_message = "network_acls.default_action must be Allow or Deny."
  }
  validation {
    condition     = contains(["AzureServices", "None"], var.network_acls.bypass)
    error_message = "network_acls.bypass must be AzureServices or None."
  }
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the vault's private endpoint. Null creates no endpoint; the caller then owns private access."
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs for privatelink.vaultcore.usgovcloudapi.net, attached to the private endpoint."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "access_policy" {
  description = "List of access policies for the Key Vault. Note: It's not possible to use both inline access_policy blocks and azurerm_key_vault_access_policy resources."
  type = list(object({
    tenant_id               = string
    object_id               = string
    application_id          = optional(string)
    certificate_permissions = optional(list(string))
    key_permissions         = optional(list(string))
    secret_permissions      = optional(list(string))
    storage_permissions     = optional(list(string))
  }))
  default = []
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
