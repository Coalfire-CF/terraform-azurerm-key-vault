variable "key_vault_id" {
  description = "The ID of the Key Vault where the key will be created"
  type        = string
}

variable "name" {
  description = "Name of the Key Vault key"
  type        = string
}

variable "key_type" {
  description = "Type of key (RSA or EC). FedRAMP requires RSA-2048 or higher, or EC P-256 or higher"
  type        = string
  default     = "RSA"
  validation {
    condition     = contains(["RSA", "RSA-HSM", "EC", "EC-HSM"], var.key_type)
    error_message = "Key type must be RSA, RSA-HSM, EC, or EC-HSM"
  }
}

variable "key_size" {
  description = "Size of the RSA key (2048, 3072, or 4096). FedRAMP requires minimum 2048"
  type        = number
  default     = 4096
  validation {
    condition = (
      var.key_type == "EC" || var.key_type == "EC-HSM" ? true :
      contains([2048, 3072, 4096], var.key_size)
    )
    error_message = "Key size must be 2048, 3072, or 4096 for FedRAMP compliance"
  }
}

variable "curve" {
  description = "Elliptic curve name for EC keys (P-256, P-384, P-521). FedRAMP requires P-256 or higher"
  type        = string
  default     = "P-256"
  validation {
    condition = (
      var.key_type == "RSA" || var.key_type == "RSA-HSM" ? true :
      contains(["P-256", "P-384", "P-521", "P-256K"], var.curve)
    )
    error_message = "Curve must be P-256, P-384, P-521, or P-256K"
  }
}

variable "key_opts" {
  description = "List of key operations"
  type        = list(string)
  default     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  validation {
    condition = alltrue([
      for opt in var.key_opts : contains([
        "decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"
      ], opt)
    ])
    error_message = "Invalid key operation specified"
  }
}

variable "expiration_date" {
  description = "Expiration date of the key in RFC3339 format. FedRAMP requires key rotation"
  type        = string
  default     = null
}

variable "rotation_policy_enabled" {
  description = "Enable automatic key rotation policy"
  type        = bool
  default     = true
}

variable "rotation_time_before_expiry" {
  description = "Time before expiry to automatically rotate the key"
  type        = string
  default     = "P30D" # 30 days before expiry
}

variable "rotation_expire_after" {
  description = "Time after creation when the key expires."
  type        = string
  default     = "P90D" # 90 days - adjust based on your org's requirements
}

variable "rotation_notify_before_expiry" {
  description = "Time before expiry to send notification"
  type        = string
  default     = "P29D" # 29 days before expiry
}

variable "tags" {
  description = "Tags to apply to the key"
  type        = map(string)
  default = {
    Compliance = "FedRAMP"
    ManagedBy  = "Terraform"
  }
}