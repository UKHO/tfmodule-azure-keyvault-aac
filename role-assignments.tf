resource "azurerm_role_assignment" "keyvault_secrets_role" {
    count                = var.enable_rbac ? 1 : 0
    scope                = azurerm_key_vault.kv.id
    role_definition_name = "Key Vault Secrets Officer"
    principal_id         = local.principal_id
}

resource "azurerm_key_vault_access_policy" "kv_access" {
    count        = var.enable_rbac ? 0 : 1
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

resource "azurerm_role_assignment" "appconf_dataowner" {
    depends_on           = [ azurerm_app_configuration.appconfig ]
    scope                = azurerm_app_configuration.appconfig.id
    role_definition_name = "App Configuration Data Owner"
    principal_id         = local.principal_id
}