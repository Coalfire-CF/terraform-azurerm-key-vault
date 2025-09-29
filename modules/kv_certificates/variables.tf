variable "certificate_name" {
  description = "The name of the certificate"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,127}$", var.certificate_name))
    error_message = "Certificate name may only contain alphanumeric characters and dashes and must be between 1-127 characters."
  }
}

variable "key_vault_id" {
  description = "The ID of the Key Vault where the certificate will be stored"
  type        = string
}

variable "certificate_policy" {
  description = "Certificate policy configuration for generating certificates"
  type = object({
    issuer_name            = optional(string, "Self")
    exportable             = optional(bool, true)
    key_size               = optional(number, 4096)
    key_type               = optional(string, "RSA")
    reuse_key              = optional(bool, false)
    curve                  = optional(string)
    content_type           = optional(string, "application/x-pkcs12")
    extended_key_usage     = optional(list(string), ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"])
    key_usage              = optional(list(string), ["digitalSignature", "keyEncipherment"])
    validity_in_months     = optional(number, 12)
    subject_alternative_names = optional(object({
      dns_names = optional(list(string), [])
      emails    = optional(list(string), [])
      upns      = optional(list(string), [])
    }))
    lifetime_action = optional(object({
      action_type          = optional(string, "AutoRenew")
      days_before_expiry   = optional(number, 30)
      lifetime_percentage  = optional(number)
    }), {
      action_type        = "AutoRenew"
      days_before_expiry = 30
    })
  })
  default = null
}

variable "certificate_contents" {
  description = "Certificate contents for importing existing certificates"
  type = object({
    contents = string
    password = optional(string)
  })
  default   = null
  sensitive = true
}

variable "tags" {
  description = "Resource level tags"
  type        = map(string)
  default     = {}
}

variable "regional_tags" {
  description = "Regional level tags"
  type        = map(string)
  default     = {}
}

variable "global_tags" {
  description = "Global level tags"
  type        = map(string)
  default     = {}
}

variable "enable_auto_renewal" {
  description = "Enable automatic certificate renewal"
  type        = bool
  default     = true
}

variable "certificate_type" {
  description = "Type of certificate to create: 'generate' for self-signed/CA-signed certificates, 'import' for importing existing certificates"
  type        = string
  default     = "generate"
  validation {
    condition     = contains(["generate", "import"], var.certificate_type)
    error_message = "Certificate type must be either 'generate' or 'import'."
  }
}

variable "subject_common_name" {
  description = "Common Name (CN) for the certificate subject"
  type        = string
}

variable "subject_organization" {
  description = "Organization (O) for the certificate subject"
  type        = string
}

variable "subject_organizational_unit" {
  description = "Organizational Unit (OU) for the certificate subject"
  type        = string
}

variable "subject_country" {
  description = "Country (C) for the certificate subject"
  type        = string
  validation {
    condition     = length(var.subject_country) == 2
    error_message = "Country must be a 2-character ISO country code."
  }
}

variable "subject_state" {
  description = "State or Province (ST) for the certificate subject"
  type        = string
}

variable "subject_locality" {
  description = "Locality (L) for the certificate subject"
  type        = string
}
