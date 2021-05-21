resource "azurerm_cosmosdb_account" "default" {
  name                      = "account-${random_id.default.hex}"
  location                  = azurerm_resource_group.default.location
  resource_group_name       = azurerm_resource_group.default.name
  offer_type                = var.edition
  kind                      = var.kind_db["2"]
  enable_automatic_failover = false
  enable_free_tier          = false

  consistency_policy {
    consistency_level = var.consistency_db["3"]
  }

  capabilities {
    name = var.capabilities_db["1"]
  }

  capabilities {
    name = var.capabilities_db["2"]
  }

  geo_location {
    location          = azurerm_resource_group.default.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_mongo_database" "default" {
  name                = "db-btf-dev-01"
  resource_group_name = azurerm_cosmosdb_account.default.resource_group_name
  account_name        = azurerm_cosmosdb_account.default.name
  throughput          = 400

  depends_on = [azurerm_cosmosdb_account.default]

}

resource "azurerm_cosmosdb_mongo_collection" "person" {
  name                = "person"
  resource_group_name = azurerm_cosmosdb_account.default.resource_group_name
  account_name        = azurerm_cosmosdb_account.default.name
  database_name       = azurerm_cosmosdb_mongo_database.default.name

  index {
    keys = ["_id"]
    unique = true
  }

    lifecycle {
    ignore_changes = [index]
  }

  depends_on = [azurerm_cosmosdb_mongo_database.default]

}

resource "azurerm_cosmosdb_mongo_collection" "music" {
  name                = "music"
  resource_group_name = azurerm_cosmosdb_account.default.resource_group_name
  account_name        = azurerm_cosmosdb_account.default.name
  database_name       = azurerm_cosmosdb_mongo_database.default.name

  index {
    keys = ["_id"]
    unique = true
  }

    lifecycle {
    ignore_changes = [index]
  }

  depends_on = [azurerm_cosmosdb_mongo_database.default, azurerm_cosmosdb_mongo_collection.music]

}