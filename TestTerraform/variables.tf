variable "location" {
  type        = string
  description = "Default resources location"
}
 
variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}
 
variable "resource_group_name" {
  type        = string
  description = "Storage account name"
}
 
variable "sa_web_source" {
  type        = string
  description = "Source Index Web Page Location"
}

// # ---------------------------------------------------------------------------------------------------------------------
// # Resource options
// # ---------------------------------------------------------------------------------------------------------------------

// # The prefix used for all resources in this example
// variable "prefix" {
//   description = "The name of the Azure resource group resourceID will be deployed into."
//   default     = "btf-dev-west1"
// }

// # The Azure location where all resources in this example should be created
// variable "location" {
//   description = "The Azure region the resourcepool will be deployed in"
//   default     = "West Europe"
// }

// # ---------------------------------------------------------------------------------------------------------------------
// variable "ResourceGroupName" {
//   description = "The Prefix used for all resources in this example"
//   default     = "btf-dev-west1"
// }

// variable "edition" {
//   description = "The Edition of the Database - Basic, Standard, Premium, or DataWarehouse"
//   default     = "Standard"
// }

// variable "ServiceObjective" {
//   description = "The Service Tier S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool"
//   default     = "S1"
// }

// variable "kind_db" {
//   description = "Arbitrary mapping of version"
//   type        = map(string)
//   default = {
//     1 = "GlobalDocumentDB"
//     2 = "MongoDB"
//   }
// }

// variable "consistency_db" {
//   description = "Arbitrary mapping of version"
//   type        = map(string)
//   default = {
//     1 = "Strong"
//     2 = "Bounded staleness"
//     3 = "Session"
//     4 = "Consistent prefix"
//     5 = "Eventual"
//   }
// }

// variable "capabilities_db" {
//   description = "Arbitrary mapping of version"
//   type        = map(string)
//   default = {
//     1  = "EnableMongo"
//     2  = "AllowSelfServeUpgradeToMongo36"
//     3  = "EnableServerless"
//     4  = "EnableCassandra"
//     5  = "EnableGremlin"
//     6  = "DisableRateLimitingResponses"
//     7  = "EnableTable"
//     8  = "MongoDBv3.4"
//     9  = "mongoEnableDocLevelTTL"
//     10 = "EnableAggregationPipeline"
//   }
// }