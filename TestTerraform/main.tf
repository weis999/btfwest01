#############  AZU Provider    #############
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "terraformstorage99abc123"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    access_key           = "storagekey"
  }
}

data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "tamops" {
  name     = var.resource_group_name
  location = var.location 
}

############# TLS Provider     #############
provider "tls" {}

############# TLS Provider     #############
provider "local" {}

############# NULL Provider     #############
provider "null" {}

############# Random Provider     #############
resource "random_id" "server" {
  keepers     = {}
  byte_length = 8
}

#####  Random id suffix configuration #####
resource "random_id" "id" {
  byte_length = 8
}