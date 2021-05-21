module "web_app" {
  source = "./web-app"
  name = format("test-%s", random_id.default.hex)
  resource_group_name = azurerm_resource_group.default.name

  runtime = {
    name    = "python"
    version = "3.6"
  }

  # These are app specific environment variables
  app_settings = {
    "COSMOSDB" = "mongodb://${azurerm_cosmosdb_account.default.name}:${azurerm_cosmosdb_account.default.primary_master_key}@${azurerm_cosmosdb_account.default.name}.documents.azure.com:10255/${azurerm_cosmosdb_mongo_database.default.name}?ssl=true&retrywrites=false"
  }

  plan = {
    tier = "Free"
    size = "F1"
  }

  depends_on = [azurerm_cosmosdb_mongo_database.default, azurerm_cosmosdb_mongo_collection.person, azurerm_cosmosdb_mongo_collection.music]

}