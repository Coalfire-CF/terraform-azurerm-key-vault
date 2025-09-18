# =====================================================
# REQUIRED VALUES - YOU MUST FILL THESE IN
# =====================================================

# Azure Key Vault Information (from your existing setup)
key_vault_name      = "kw-sandbox-kv-39"
resource_group_name = "kw-sandbox-va-mgmt-core-rg"

# =====================================================
# OPTIONAL VALUES - MODIFY AS NEEDED
# =====================================================

# Certificate name (will appear in Key Vault)
certificate_name = "test-self-signed-cert"

# Domain for testing (can be fake since it's self-signed)
test_domain = "test.coalfirese.onmicrosoft.us"

# Subject Alternative Names
subject_alternative_names = [
  "test.coalfirese.onmicrosoft.us",
  "api.coalfirese.onmicrosoft.us"
]

# Certificate Subject Information
organization_name    = "Coalfire Systems Inc"
organizational_unit  = "Systems Engineering"
locality            = "Westminster"
state               = "Colorado"
country             = "US"

# Certificate Options
enable_auto_renewal = true

# Tags
global_tags = {
  Environment = "Sandbox"
  Project     = "KV-Certificates-Test"
  Owner       = "Lucas Sousa"
}

regional_tags = {
  Region = "USGov-Virginia"
}
