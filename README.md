# terraform-module-template for an app config and a keyvault pair deployment

Example usage: 

module "keyvault_appconfig" {
  source              = "github.com/UKHO/terraform-azure-keyvault-appconfig"
  resource_group_name = var.resource_grou_name
  location            = var.location
  keyvault_name       = var.kv_name
  tenant_id           = var.tenant_id
  enable_rbac         = false
  appconfig_name      = var.aac_name

  appconfig_keys = {
    "example key" = "enabled"
    "API_URL"     = "https://api.example.com"
  }

  appconfig_kv_secrets = ["ExampleAPIKey, "StorageKey"]
}

