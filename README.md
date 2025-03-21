# Terraform Module: for Azure Private Endpoints

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

variable "appconfig_keys" {
  description = "Map of keys and values to add to the App Configuration"
  type        = map(string)
  default     = {}
}

variable "appconfig_kv_secrets" {
  description = "Map of Key Vault secrets to import into App Configuration"
  type        = list(string)
  default     = []
}


Example usage: 

module "keyvault_appconfig" {
  source              = "github.com/UKHO/terraform-azure-keyvault-appconfig"
  resource_group_name = local.rg
  location            = local.location
  keyvault_name       = local.kv_name
  tenant_id           = local.tenant_id
  enable_rbac         = false
  kv_sku              = local.kv_sku
  ip_rules            = local.ip_rules
  subnet_ids          = local.subnet_ids
  appconfig_name      = local.aac_name
  aac_sku             = local.aac_sku
  tags                = local.tags
secrets = {
    "DatabasePassword" = "ExampleSecret"
    "StorageKey"       = "123ABC"
    }
}
