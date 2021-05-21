locals {
  default_plan_name = format("%s-plan", var.name)

  plan = merge({
    id       = ""
    name     = ""
    sku_size = "F1"
    os_type  = "linux"
  }, var.plan)

  location = coalesce(var.location, data.azurerm_resource_group.main.location)

  runtime = merge({
    name    = "node"
    version = ""
  }, var.runtime)

  runtime_name = lower(local.runtime.name)

  # FIXME: create a data source to get list of supported runtimes and SKUs
  runtime_versions = {
    windows = {
      aspnet = ["4.7", "3.5"]
      node   = ["10.6", "10.0", "8.11", "8.10", "8.9", "8.5", "8.4", "8.1", "7.10", "6.12", "6.9", "6.5", "4.8", "0.12", "0.10", "0.8", "0.6"]
      php    = ["7.3", "7.2", "7.1", "7.0", "5.6"]
      python = ["3.6", "2.7"]
      java   = ["11", "1.8", "1.7"]
    }
    linux = {
      ruby       = ["2.6.2", "2.5.5", "2.4.5", "2.3.8"]
      node       = ["lts", "10.14", "10.12", "10.10", "10.1", "9.4", "8.12", "8.11", "8.9", "8.8", "8.2", "8.1", "8.0", "6.11", "6.10", "6.9", "6.6", "6.2", "4.8", "4.5", "4.4"]
      php        = ["7.3", "7.2", "7.0", "5.6"]
      dotnetcore = ["3.1", "3.0", "2.2", "2.1", "2.0", "1.1", "1.0"]
      java       = ["11-java11", "8-jre"]
      tomcat     = ["9.0-java11", "8.5-java11", "9.0-jre8", "8.5-jre8"]
      wildfly    = ["14-jre8"]
      python     = ["3.7", "3.6", "2.7"]
    }
  }
  supported_runtimes = {
    for os_type, runtime in local.runtime_versions :
    os_type => {
      for name, versions in runtime :
      name => {
        for version in versions :
        version => true
      }
    }
  }
  linux_runtime_versions   = flatten([for k, v in local.runtime_versions.linux : v if k == local.runtime_name])
  windows_runtime_versions = flatten([for k, v in local.runtime_versions.windows : v if k == local.runtime_name])

  runtime_version = (
    local.runtime.version != "" ? local.runtime.version :
    length(local.linux_runtime_versions) > 0 ? local.linux_runtime_versions[0] :
    length(local.windows_runtime_versions) > 0 ? local.linux_runtime_versions[0] :
    ""
  )

  os_type = (
    contains(local.linux_runtime_versions, local.runtime_version) ? "linux" :
    contains(local.windows_runtime_versions, local.runtime_version) ? "windows" :
    lower(local.plan.os_type)
  )

  check_supported_runtime = local.supported_runtimes[local.os_type][local.runtime_name][local.runtime_version]

  sku_sizes = {
    "Free"             = ["F1", "Free"]
    "Shared"           = ["D1", "Shared"]
    "Basic"            = ["B1", "B2", "B3"]
    "Standard"         = ["S1", "S2", "S3"]
    "Premium"          = ["P1", "P2", "P3"]
    "PremiumV2"        = ["P1v2", "P2v2", "P3v2"]
    "PremiumContainer" = ["PC2", "PC3", "PC4"]
    "ElasticPremium"   = ["EP1", "EP2", "EP3"]
  }
  skus = flatten([
    for tier, sizes in local.sku_sizes : [
      for size in sizes : {
        tier = tier
        size = size
      }
    ]
  ])
  sku_tiers = { for sku in local.skus : sku.size => sku.tier }

  is_shared = contains(["F1", "FREE", "D1", "SHARED"], upper(local.plan.sku_size))

  always_on = local.is_shared ? false : true

  use_32_bit_worker_process = local.is_shared ? true : false

  dotnet_clr_versions = {
    "3.5" = "v2.0"
    "4.7" = "v4.0"
  }
  dotnet_framework_version = local.runtime_name == "aspnet" ? local.dotnet_clr_versions[local.runtime_version] : null

  php_version = local.os_type == "windows" && local.runtime_name == "php" ? local.runtime_version : null

  python_version = local.os_type == "windows" && local.runtime_name == "python" ? local.runtime_version : null

  linux_fx_version = local.os_type == "linux" ? format("%s|%s", upper(local.runtime.name), local.runtime_version) : null

  node_default_version = local.os_type == "windows" ? {
    WEBSITE_NODE_DEFAULT_VERSION = local.runtime_name == "node" ? local.runtime_version : "8.11.1"
  } : {}

  app_settings = merge(
    var.app_settings,
    local.node_default_version
  )

  scaling = merge({
    enabled   = false
    min_count = 1
    max_count = 3
    rules = [
      {
        condition = "CpuPercentage > 75 avg 5m"
        scale     = "out 1"
      },
      {
        condition = "CpuPercentage < 30 avg 10m"
        scale     = "in 1"
      }
    ]
  }, var.scaling)

  scaling_rules = [
    for r in local.scaling.rules : merge({
      condition  = ""
      scale      = ""
      cooldown   = 5
      time_grain = "avg 1m"
    }, r)
  ]

  operator_conversion = {
    "="  = "Equals"
    "!=" = "NotEquals"
    ">"  = "GreaterThan"
    ">=" = "GreaterThanOrEqual"
    "<"  = "LessThan"
    "<=" = "LessThanOrEqual"
  }

  time_aggregation_conversion = {
    avg   = "Average"
    min   = "Minimum"
    max   = "Maximum"
    total = "Total"
    count = "Count"
  }

  scale_direction_conversion = {
    to  = "None"
    out = "Increase"
    in  = "Decrease"
  }

  statistic_conversion = {
    avg = "Average"
    min = "Min"
    max = "Max"
  }

  condition_pattern = "/^([\\w\\s]*)\\s([!=><]*)\\s(\\d*)\\s(avg|min|max|total|count)\\s(\\d*[d|h|m|s])$/"

  metric_triggers = [
    for r in local.scaling_rules : {
      metric_name        = replace(r.condition, local.condition_pattern, "$1")
      metric_resource_id = azurerm_app_service.main.app_service_plan_id
      time_grain         = format("PT%s", upper(split(" ", r.time_grain)[1]))
      statistic          = local.statistic_conversion[split(" ", r.time_grain)[0]]
      time_window        = format("PT%s", upper(replace(r.condition, local.condition_pattern, "$5")))
      time_aggregation   = local.time_aggregation_conversion[replace(r.condition, local.condition_pattern, "$4")]
      operator           = local.operator_conversion[replace(r.condition, local.condition_pattern, "$2")]
      threshold          = format("%d", replace(r.condition, local.condition_pattern, "$3"))
    }
  ]

  scale_pattern = "/^(to|out|in)\\s(\\d*)(%?)$/"

  scale_actions = [
    for r in local.scaling_rules : {
      direction = local.scale_direction_conversion[split(" ", r.scale)[0]]
      type = (
        split(" ", r.scale)[0] == "to" ?
        "ExactCount" :
        replace(r.scale, local.scale_pattern, "$3") != "" ?
        "PercentChangeCount" :
        "ChangeCount"
      )
      value    = replace(r.scale, local.scale_pattern, "$2")
      cooldown = format("PT%dM", r.cooldown)
    }
  ]

  client_affinity_enabled = local.scaling.enabled ? true : false

}