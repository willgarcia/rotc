variable "location" {
  type = string
  default = "East US"
}

variable "prefix" {
    type = string
    description = "Give YOUR cluster a unique prefix (3-45 alpha characters)"
}

variable "aks_service_principal_app_id" {
  type = string
  description = "Service Principal App ID"
}

variable "aks_service_principal_client_secret" {
  type = string
  description = "Service Principal password"
}