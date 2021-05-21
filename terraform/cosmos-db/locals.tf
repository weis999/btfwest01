locals {
  default_plan_name = format("%s-plan", var.name)

  plan = merge({
    id       = ""
    name     = ""
  }, var.plan)

  location = coalesce(var.location, data.azurerm_resource_group.main.location)

  default_failover_locations = {
    default = {
      location = var.location
    }
  }

  condition_pattern = "/^([\\w\\s]*)\\s([!=><]*)\\s(\\d*)\\s(avg|min|max|total|count)\\s(\\d*[d|h|m|s])$/"

}