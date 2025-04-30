output "keyvault_id" {
    value = azurerm_key_vault.kv.id
}

output "appconfig_id" {
    value = azurerm_app_configuration.appconfig.id
}

output "appconfig_connection_string" {
    value = azurerm_app_configuration.appconfig.primary_read_key[0].connection_string
}