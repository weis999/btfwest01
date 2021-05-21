terraform {
  backend "azurerm" {
    resource_group_name  = "__BackendStorageResourceGroupName__"
    storage_account_name = "__BackendStorageAccountName__"
    container_name       = "__BackendStorageContainerName__"
    key                  = "__BackendStorageKey__"
    access_key           = "__BackendStorageKey__"
  }

  required_providers {
    azurerm = {
      # Specify what version of the provider we are going to utilise
      source  = "hashicorp/azurerm"
      version = ">= 2.4.1"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

############# TLS Provider     #############
provider "tls" {}

############# TLS Provider     #############
provider "local" {}

############# NULL Provider     #############
provider "null" {}

#####  Random id suffix configuration #####
resource "random_id" "default" {
  byte_length = 4
}

############# resource Provider     #############
resource "azurerm_resource_group" "default" {
  name     = format("test-%s", random_id.default.hex)
  location = "westeurope"
}