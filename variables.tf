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

variable "object_id" {
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
  description = "Map of Key Vault secrets (name → value) that should be created"
  type        = map(string)
  default     = {}
}