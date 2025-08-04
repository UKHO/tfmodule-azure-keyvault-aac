terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

provider "azurerm" {
  alias = "hub"
  features {}

  subscription_id = var.hub_subscription_id
}