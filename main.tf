resource "azurerm_key_vault" "kv" {
    name                          = var.keyvault_name
    location                      = var.location
    resource_group_name           = var.resource_group_name
    sku_name                      = var.kv_sku
    tenant_id                     = var.tenant_id
    rbac_authorization_enabled    = var.enable_rbac
    enabled_for_disk_encryption   = true
    soft_delete_retention_days    = 7
    purge_protection_enabled      = true
    tags                          = var.tags
    public_network_access_enabled = var.pe_enabled ? false : true
    
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

resource "azurerm_role_assignment" "keyvault_secrets_role" {
    scope                = azurerm_key_vault.kv.id
    role_definition_name = "Key Vault Secrets Officer"
    principal_id         = local.principal_id
}

resource "azurerm_key_vault_access_policy" "kv_access" {
    depends_on   = [ azurerm_key_vault.kv ]
    key_vault_id = azurerm_key_vault.kv.id
    tenant_id    = var.tenant_id
    object_id    = local.principal_id

    secret_permissions = [
        "Get",
        "Set",
        "List",
        "Delete"
    ]
}

resource "azurerm_key_vault_secret" "kv_secrets" {
    depends_on      = [ azurerm_key_vault_access_policy.kv_access, azurerm_role_assignment.keyvault_secrets_role ]
    for_each        = var.secrets
    name            = replace(lower(each.key), "__", "-")
    value           = each.value.value
    key_vault_id    = azurerm_key_vault.kv.id
    tags            = var.tags
    content_type    = each.value.content_type
    expiration_date = "2299-12-31T23:59:59Z"
}

resource "azurerm_app_configuration" "appconfig" {
    name                  = var.appconfig_name
    location              = var.location
    resource_group_name   = var.resource_group_name
    sku                   = var.aac_sku
    tags                  = var.tags
    public_network_access = var.pe_enabled ? "Disabled" : "Enabled"
}

resource "azurerm_role_assignment" "appconf_dataowner" {
    depends_on           = [ azurerm_app_configuration.appconfig ]
    scope                = azurerm_app_configuration.appconfig.id
    role_definition_name = "App Configuration Data Owner"
    principal_id         = local.principal_id
}

resource "azurerm_app_configuration_key" "kv_secrets" {
    depends_on             = [ azurerm_key_vault_secret.kv_secrets, azurerm_role_assignment.appconf_dataowner ]
    for_each               = var.secrets
    configuration_store_id = azurerm_app_configuration.appconfig.id
    type                   = "vault"
    key                    = replace(each.key, "__", ":")
    vault_key_reference    = "${azurerm_key_vault.kv.vault_uri}secrets/${replace(lower(each.key), "__", "-")}"
}

resource "azurerm_app_configuration_key" "appconf_items" {
    depends_on             = [ azurerm_role_assignment.appconf_dataowner ]
    for_each               = var.items
    configuration_store_id = azurerm_app_configuration.appconfig.id
    key                    = replace(each.key, "__", ":")
    value                  = each.value
}
