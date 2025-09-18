# Key Vault Certificates Module Test

This directory contains tests for the `kv_certificates` module using a self-signed certificate.

## Prerequisites

1. **Azure CLI**: Install and login to Azure
2. **Terraform**: Version 1.0 or later
3. **Existing Key Vault**: You need an existing Azure Key Vault with appropriate permissions

## Azure CLI Setup

### 1. Install Azure CLI (if not installed)
```bash
# macOS
brew install azure-cli

# Or download from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
```

### 2. Login to Azure Government
```bash
# Set cloud environment to US Government
az cloud set --name AzureUSGovernment

# Login (this will open a browser)
az login

# Verify you're logged in and see your subscriptions
az account list --output table

# Set the correct subscription if you have multiple
az account set --subscription "YOUR_SUBSCRIPTION_ID_OR_NAME"
```

### 3. Verify Key Vault Access
```bash
# Test that you can access your Key Vault
az keyvault show --name "kw-sandbox-kv-39" --resource-group "kw-sandbox-va-mgmt-core-rg"

# Check if you have certificate permissions
az keyvault certificate list --vault-name "kw-sandbox-kv-39"
```

## Terraform Setup

### 1. Install Terraform (if using tfenv)
```bash
# Install latest 1.x version
tfenv install latest:^1
tfenv use latest:^1

# Verify installation
terraform version
```

### 2. Configure Variables
Edit `terraform.tfvars` and update any values you want to customize. The file is already pre-configured with your Key Vault details.

## Running the Test

### 1. Navigate to Test Directory
```bash
cd modules/kv_certificates/test
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Plan the Deployment
```bash
terraform plan
```

### 4. Apply the Configuration
```bash
terraform apply
```

### 5. View Outputs
```bash
terraform output
```

### 6. Clean Up (when done testing)
```bash
terraform destroy
```

## What This Test Does

1. **Connects** to your existing Key Vault (`kw-sandbox-kv-39`)
2. **Creates** a self-signed certificate with:
   - 4096-bit RSA key (FedRAMP compliant)
   - 12-month validity
   - Auto-renewal 30 days before expiration
   - Subject: `CN=test.coalfirese.onmicrosoft.us,OU=Systems Engineering,O=Coalfire Systems Inc,L=Westminster,ST=Colorado,C=US`
   - SANs: `test.coalfirese.onmicrosoft.us`, `api.coalfirese.onmicrosoft.us`
3. **Outputs** all certificate details for verification

## Expected Outputs

After successful deployment, you should see:
- Certificate ID and name
- Certificate thumbprint
- Certificate subject and SANs
- Certificate expiration date
- Key Vault information

## Troubleshooting

### Common Issues

1. **Authentication Error**
   ```
   Error: building AzureRM Client: obtain subscription() from Azure CLI: parsing json result from the Azure CLI
   ```
   **Solution**: Run `az login` and ensure you're authenticated

2. **Key Vault Not Found**
   ```
   Error: retrieving Key Vault: keyvaults.Client#Get: Failure responding to request
   ```
   **Solution**: Verify the Key Vault name and resource group are correct

3. **Permission Denied**
   ```
   Error: creating/updating Certificate: keyvault.BaseClient#SetCertificate: Failure sending request
   ```
   **Solution**: Check that your account has "Key Vault Certificate Officer" or equivalent permissions

4. **Provider Not Found**
   ```
   Error: Failed to query available provider packages
   ```
   **Solution**: Run `terraform init` to download providers

### Getting Help

If you encounter issues:
1. Check the Azure portal to verify the Key Vault exists and you have access
2. Run `az account show` to verify you're authenticated to the correct subscription
3. Check the Terraform plan output for any obvious configuration issues

## Next Steps

After this test passes:
1. Verify the certificate appears in the Azure Key Vault portal
2. Test certificate renewal by setting a shorter validity period
3. Consider adding Let's Encrypt CA-signed certificate test
