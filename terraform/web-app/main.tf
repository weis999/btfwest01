data "azurerm_client_config" "main" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_app_service_plan" "main" {
  count               = local.plan.id != "" ? 1 : 0
  name                = split("/", local.plan.id)[8]
  resource_group_name = split("/", local.plan.id)[4]
}

resource "azurerm_app_service_plan" "main" {
  count               = local.plan.id == "" ? 1 : 0
  name                = coalesce(local.plan.name, local.default_plan_name)
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  kind                = local.os_type
  reserved            = local.os_type == "linux" ? true : null

  sku {
    tier = local.sku_tiers[local.plan.sku_size]
    size = local.plan.sku_size
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_app_service" "main" {
  name                = var.name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  app_service_plan_id = coalesce(local.plan.id, azurerm_app_service_plan.main[0].id)

  https_only              = var.https_only
  client_affinity_enabled = local.client_affinity_enabled

  site_config {
    always_on                 = local.always_on
    http2_enabled             = var.http2_enabled
    ftps_state                = var.ftps_state
    min_tls_version           = var.min_tls_version
    use_32_bit_worker_process = local.use_32_bit_worker_process

    dotnet_framework_version = local.dotnet_framework_version
    php_version              = local.php_version
    python_version           = local.python_version

    linux_fx_version = local.linux_fx_version

    dynamic "ip_restriction" {
      for_each = toset(var.ip_restrictions)

      content {
        ip_address = ip_restriction.key
      }
    }

  }
}

resource "azurerm_monitor_autoscale_setting" "main" {
  count               = local.scaling.enabled ? 1 : 0
  name                = format("%s-autoscale", var.name)
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  target_resource_id  = azurerm_app_service.main.app_service_plan_id

  profile {
    name = "default"

    capacity {
      default = local.scaling.min_count
      minimum = local.scaling.min_count
      maximum = local.scaling.max_count
    }

    dynamic "rule" {
      for_each = { for k, v in local.scaling_rules : k => v }

      content {
        metric_trigger {
          metric_name        = local.metric_triggers[rule.key].metric_name
          metric_resource_id = local.metric_triggers[rule.key].metric_resource_id
          time_grain         = local.metric_triggers[rule.key].time_grain
          statistic          = local.metric_triggers[rule.key].statistic
          time_window        = local.metric_triggers[rule.key].time_window
          time_aggregation   = local.metric_triggers[rule.key].time_aggregation
          operator           = local.metric_triggers[rule.key].operator
          threshold          = local.metric_triggers[rule.key].threshold
        }

        scale_action {
          direction = local.scale_actions[rule.key].direction
          type      = local.scale_actions[rule.key].type
          value     = local.scale_actions[rule.key].value
          cooldown  = local.scale_actions[rule.key].cooldown
        }
      }
    }
  }
}