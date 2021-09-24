# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used 
terraform {
  backend "azurerm" {
  }
}

# Configure the Azure provider
provider "azurerm" {
    skip_provider_registration = true
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
    features {}
}

# Create resource group
resource "azurerm_resource_group" "odysseus-group" {
    name     = "Odysseus-${var.sourceBranchName}"
    location = "${var.location}"

    tags = {
        Odysseus = "${var.sourceBranchName}"
    }
}

# Create storage account
resource "azurerm_storage_account" "odysseus-storageaccount" {
    name                        = "Odysseus-${var.sourceBranchName}"
    resource_group_name         = azurerm_resource_group.odysseus-group.name
    location                    = azurerm_resource_group.odysseus-group.location
    account_replication_type    = "${var.storage_replication_type}"
    account_tier                = "${var.storage_account_tier}"

    tags = {
        Odysseus = azurerm_resource_group.odysseus-group.tags.Odysseus
    }
}

# Create container
resource "azurerm_storage_container" "odysseus-container" {
  name                 = "Odysseus-container-${var.sourceBranchName}"
  storage_account_name = azurerm_storage_account.odysseus-storageaccount.name
}