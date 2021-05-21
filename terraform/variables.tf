variable "resource_group_name" {
  description = "Default resource group name."
  type        = list(string)
  default     = ["btf01-acc-west1", "btf02-acc-west1"]
}

variable "location" {
  description = "The location/region where the core network will be created."
  default     = "westeurope"
}

variable "edition" {
  description = "The Edition of the Database - Basic, Standard, Premium, or DataWarehouse"
  default     = "Standard"
}

variable "kind_db" {
  description = "Arbitrary mapping of version"
  type        = map(string)
  default = {
    1 = "GlobalDocumentDB"
    2 = "MongoDB"
  }
}

variable "consistency_db" {
  description = "Arbitrary mapping of version"
  type        = map(string)
  default = {
    1 = "Strong"
    2 = "Bounded staleness"
    3 = "Session"
    4 = "Consistent prefix"
    5 = "Eventual"
  }
}

variable "capabilities_db" {
  description = "Arbitrary mapping of version"
  type        = map(string)
  default = {
    1  = "EnableMongo"
    2  = "AllowSelfServeUpgradeToMongo36"
    3  = "EnableServerless"
    4  = "EnableCassandra"
    5  = "EnableGremlin"
    6  = "DisableRateLimitingResponses"
    7  = "EnableTable"
    8  = "MongoDBv3.4"
    9  = "mongoEnableDocLevelTTL"
    10 = "EnableAggregationPipeline"
  }
}