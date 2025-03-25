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

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault_access_policy" "kv_access" {
    depends_on = [ azurerm_key_vault.kv ]
    key_vault_id = azurerm_key_vault.kv.id
    tenant_id    = var.tenant_id
    object_id    = data.azurerm_client_config.current.object_id

    secret_permissions = [
        "Get",
        "Set",
        "List"
    ]
}

resource "azurerm_key_vault_secret" "kv_secrets" {
    depends_on = [ azurerm_key_vault_access_policy.kv_access ]
    for_each     = var.secrets
    name         = each.key
    value        = each.value
    key_vault_id = azurerm_key_vault.kv.id
    content_type = "text/plain"
    tags         = var.tags
}

resource "azurerm_app_configuration" "appconfig" {
    name                = var.appconfig_name
    location            = var.location
    resource_group_name = var.resource_group_name
    sku                 = var.aac_sku
    tags                = var.tags
}

resource "azurerm_role_assignment" "appconf_dataowner" {
    depends_on = [ azurerm_app_configuration.appconfig ]
    scope                = azurerm_app_configuration.appconf
    role_definition_name = "App Configuration Data Owner"
    principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_app_configuration_key" "kv_secrets" {
    depends_on             = [ azurerm_key_vault_secret.kv_secrets, azurerm_role_assignment.appconf_dataowner]
    for_each               = var.secrets
    configuration_store_id = azurerm_app_configuration.appconfig.id
    type                   = "vault"
    key                    = each.key
    vault_key_reference    = "${azurerm_key_vault.kv.vault_uri}secrets/${each.key}"
}
