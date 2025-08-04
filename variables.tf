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
  description = "Azure Subscription ID"
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
  description = "SKU of the Key Vault (standard or premium)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.kv_sku)
    error_message = "Valid values for kv_sku are 'standard' or 'premium'."
  }
}

variable "aac_sku" {
  description = "SKU of the App Configuration (free or standard)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["free", "standard"], var.aac_sku)
    error_message = "Valid values for aac_sku are 'free' or 'standard'."
  }
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}

variable "ip_rules" {
  description = "List of IP addresses that are allowed to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs that are allowed to access the Key Vault"
  type        = list(string)
  default     = []
}

variable "secrets" {
  description = "Map of Key Vault secrets (name → secret value) that should be created"
  type        = map(string)
  default     = {}
}

variable "items" {
  description = "Map of configuration items (name → value) that should be created"
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
    default = ""

  validation {
    condition     = var.pe_enabled == true ? length(var.pe_environment) > 0 : true
    error_message = "The pe_environment variable must be supplied"
  }
}

variable "pe_subnet_name" {
  description = "subnet name that the private endpoint will associate"
  default     = ""

  validation {
    condition     = var.pe_enabled == true ? length(var.pe_subnet_name) > 0 : true
    error_message = "The pe_subnet_name variable must be supplied"
  }
}

variable "dns_resource_group_name" {
  description = "dns resource group name, please change domain-rg to either business-rg or engineering-rg"
  default     = ""

  validation {
    condition     = var.pe_enabled == true ? length(var.dns_resource_group_name) > 0 : true
    error_message = "The dns_resource_group_name variable must be supplied"
  }
}

variable "hub_subscription_id" {
  description = "Azure Subscription ID for Hub"
  type        = string
  default     = null
}

variable "vnet_name" {
  type = string
  default     = ""

  validation {
    condition     = length(var.vnet_name) > 0
    error_message = "The vnet_name variable must be supplied"
  }
}

variable "vnet_resource_group_name" {
  type    = string
  default = "m-spokeconfig-rg"

  validation {
    condition     = length(var.vnet_resource_group_name) > 0
    error_message = "The vnet_resource_group_name variable must be supplied"
  }
}