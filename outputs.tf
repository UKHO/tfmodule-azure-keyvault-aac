output "keyvault_id" {
    value = azurerm_key_vault.kv.id
}

output "appconfig_id" {
    value = azurerm_app_configuration.appconfig.id
}
