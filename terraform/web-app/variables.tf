variable "name" {
  type        = string
  description = "The name of the web app."
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group."
}

variable "location" {
  type        = string
  default     = ""
  description = "The location where the web app should be created."
}

variable "https_only" {
  type        = bool
  default     = false
  description = "Redirect all traffic made to the web app using HTTP to HTTPS."
}

variable "http2_enabled" {
  type        = bool
  default     = true
  description = "Whether clients are allowed to connect over HTTP 2.0."
}

variable "min_tls_version" {
  type        = string
  default     = "1.2"
  description = "The minimum supported TLS version."
}

variable "ftps_state" {
  type        = string
  default     = "Disabled"
  description = "Set the FTPS state value the web app. The options are: `AllAllowed`, `Disabled` and `FtpsOnly`."
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "Map of App Settings."
}

variable "ip_restrictions" {
  type        = list(string)
  default     = []
  description = "A list of IP addresses in CIDR format specifying Access Restrictions."
}

variable "plan" {
  type        = any
  default     = {}
  description = "App Service plan properties. This should be `plan` object."
}

variable "runtime" {
  type        = any
  default     = {}
  description = "Runtime settings for the web app. This should be `runtime` object."
}

variable "auth" {
  type        = any
  default     = {}
  description = "Auth settings for the web app. This should be `auth` object."
}

variable "scaling" {
  type        = any
  default     = {}
  description = "Autoscale settings for the web app. This should be `scaling` object."
}