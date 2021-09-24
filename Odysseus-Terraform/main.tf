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

# Generate random text for a unique name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.odysseus-group.name
    }

    byte_length = 8
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
resource "azurerm_storage_account" "odysseusstorageaccount" {
    # name                        = "Odysseus-${var.sourceBranchName}"
    name                        = "${random_id.randomId.hex}${var.sourceBranchName}"
    resource_group_name         = azurerm_resource_group.odysseus-group.name
    location                    = azurerm_resource_group.odysseus-group.location
    account_replication_type    = "RAGRS"
    account_tier                = "Standard"
    account_kind                = "StorageV2"
    is_hns_enabled              = "true"
    enable_https_traffic_only   = "true"
    allow_blob_public_access    = "false"
    access_tier                 = "Hot"
    min_tls_version             = "TLS1_2"

    blob_properties {
        delete_retention_policy {
            days = 7
        }
        container_delete_retention_policy {
            days = 7
        }
    }

    identity {
        type = "SystemAssigned"
    }    

    tags = {
        Odysseus = azurerm_resource_group.odysseus-group.tags.Odysseus
    }
}

# Create container
resource "azurerm_storage_container" "odysseus-container" {
  name                 = "odysseus-container-${var.sourceBranchName}"
  storage_account_name = azurerm_storage_account.odysseusstorageaccount.name
  container_access_type = "private"
}