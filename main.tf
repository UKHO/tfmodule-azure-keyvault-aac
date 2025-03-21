resource "azurerm_key_vault" "kv" {
    name                        = var.keyvault_name
    location                    = var.location
    resource_group_name         = var.resource_group_name
    sku_name                    = var.kv_sku
    tenant_id                   = var.tenant_id
    enable_rbac_authorization   = var.enable_rbac
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = true
    tags                        = var.tags
    
    network_acls {
        bypass                     = "AzureServices"
        default_action             = "Deny"
        ip_rules                   = var.ip_rules
        virtual_network_subnet_ids = var.subnet_ids
    }

    lifecycle {
        ignore_changes = [
            tags
        ]
        }
}   

resource "azurerm_app_configuration" "appconfig" {
    name                = var.appconfig_name
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = var.aac_sku
    tags                = var.tags
}

resource "azurerm_app_configuration_key" "appconfig_keys" {
    for_each               = var.appconfig_keys
    configuration_store_id = azurerm_app_configuration.appconfig.id
    key                    = each.key
    value                  = each.value
    type                   = "string"
}

resource "azurerm_app_configuration_key" "kv_secrets" {
    for_each               = toset(var.appconfig_kv_secrets)
    configuration_store_id = azurerm_app_configuration.appconfig.id
    key                    = each.value
    vault_key_reference    = "${azurerm_key_vault.kv.vault_uri}secrets/${each.value}"
}

