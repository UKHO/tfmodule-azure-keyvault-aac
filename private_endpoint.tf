module "private_endpoint_kv" {
  source    = "github.com/UKHO/tfmodule-azure-private-endpoint-private-link?ref=0.7.0"
  providers = {
    azurerm.spoke = azurerm
    azurerm.hub   = azurerm.hub
  }

  private_connection          = [azurerm_key_vault.kv.id]
  pe_identity                 = [replace(azurerm_key_vault.kv.name, "^m-", "")]
  pe_environment              = var.pe_environment
  pe_vnet_rg                  = var.vnet_resource_group_name
  pe_vnet_name                = var.vnet_name
  pe_subnet_name              = var.pe_subnet_name
  pe_resource_group           = [var.resource_group_name]
  pe_resource_group_locations = [var.location]
  dns_resource_group          = var.dns_resource_group_name
  zone_group                  = "private-dns-zone-group"
  dns_zone                    = "privatelink.vaultcore.azure.net"
  subresource_names           = ["vault"]

  count = var.pe_enabled ? 1 : 0
}

module "private_endpoint_aac" {
  source    = "github.com/UKHO/tfmodule-azure-private-endpoint-private-link?ref=0.7.0"
  providers = {
    azurerm.spoke = azurerm
    azurerm.hub   = azurerm.hub
  }

  private_connection          = [azurerm_app_configuration.appconfig.id]
  pe_identity                 = [azurerm_app_configuration.appconfig.name]
  pe_environment              = var.pe_environment
  pe_vnet_rg                  = var.vnet_resource_group_name
  pe_vnet_name                = var.vnet_name
  pe_subnet_name              = var.pe_subnet_name
  pe_resource_group           = [var.resource_group_name]
  pe_resource_group_locations = [var.location]
  dns_resource_group          = var.dns_resource_group_name
  zone_group                  = "private-dns-zone-group"
  dns_zone                    = "privatelink.azconfig.io"
  subresource_names           = ["configurationStores"]

  count = var.pe_enabled ? 1 : 0
}