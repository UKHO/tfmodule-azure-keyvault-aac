output "keyvault_id" {
    value = azurerm_key_vault.kv.id
}

output "appconfig_id" {
    value = azurerm_app_configuration.appconfig.id
}

output "appconfig_keys_added" {
    value = keys(azurerm_app_configuration_key.appconfig_keys)
}

output "appconfig_kv_secrets_added" {
    value = keys(azurerm_app_configuration_key.kv_secrets)
}
