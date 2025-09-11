# Terraform Module: for Azure Key Vault and App Config (with key value pairs)

##

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.

## Usage

```terraform
# Azure Key Vault and Azure App Config

## Usage Vars

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "keyvault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID. If not supplied then ARM_SUBSCRIPTION_ID environment variable must be set"
  type        = string
  default     = null
}

variable "principal_id" {
  description = "The object id of the terraform principal (Optional). If not supplied then data.azurerm_client_config.current.object_id will be used"
  type        = string
  default     = null
}

variable "enable_rbac" {
  description = "Enable RBAC authorization for Key Vault"
  type        = bool
  default     = false
}

variable "appconfig_name" {
  description = "Name of the App Configuration"
  type        = string
}

variable "kv_sku" {
  description = "Sku of the key vault"
  type        = string
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}

variable "ip_rules" {
  description = "List of IP addresses that are allowed to access the key vault"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs that are allowed to access the key vault"
  type        = list(string)
  
}

variable "aac_sku" {
  description = "Sku of the App Config"
  type        = string
}

variable "secrets" {
  description = "Map of Key Vault secrets (name → object) that should be created. Each object must have 'value' and 'content_type'."
  type        = map(object({
    value        = string
    content_type = string
  }))
  default     = {}
}

variable "items" {
  description = "Map of configuration items (name → value) that should be created. If keys have '__', these will be converted to ':' for aac namespacing"
  type        = map(string)
  default     = {}
}

# PE

variable "pe_enabled" {
  description = "Enable private endpoint"
  type        = bool
  default     = false
}

variable "pe_environment" {
  description = "environment for private endpoint (for example dev | prd | qa | pre)"
  default     = ""
}

variable "pe_subnet_name" {
  description = "subnet name that the private endpoint will associate"
  default     = ""
}

variable "dns_resource_group_name" {
  description = "dns resource group name, please change domain-rg to either business-rg or engineering-rg"
  default     = ""
}

variable "hub_subscription_id" {
  description = "Azure Subscription ID for Hub"
  type        = string
  default     = null
}

variable "vnet_name" {
  type    = string
  default = ""
}

variable "vnet_resource_group_name" {
  type    = string
  default = "m-spokeconfig-rg"
}


Example usage: 

module "keyvault_appconfig" {
  source              = "github.com/UKHO/terraform-azure-keyvault-appconfig"
  resource_group_name = local.rg
  location            = local.location
  keyvault_name       = local.kv_name
  tenant_id           = local.tenant_id
  subscription_id     = var.subscription_id
  principal_id        = data.azuread_service_principal.terraform.object_id # or data.azurerm_client_config.current.object_id
  enable_rbac         = false
  kv_sku              = local.kv_sku
  ip_rules            = local.ip_rules
  subnet_ids          = local.subnet_ids
  appconfig_name      = local.aac_name
  aac_sku             = local.aac_sku
  tags                = local.tags
  secrets = {
    "DatabasePassword" = {
      value        = "var.secret"
      content_type = "text/plain"
    }
    "StorageKey" = {
      value        = "var.storage_key"
      content_type = "application/json"
    }
  }
  items = {
    "service-url" = "https://somewhere.ukho.gov.uk"
  }
  pe_enabled              = true
  hub_subscription_id     = var.hub_subscription_id
  vnet_name               = data.azurerm_virtual_network.spoke.name
  pe_environment          = var.environment
  pe_subnet_name          = data.azurerm_subnet.spoke-pe-subnet.name
  dns_resource_group_name = var.dns_resource_group
}
```