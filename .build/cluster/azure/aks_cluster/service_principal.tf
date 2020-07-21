data "azuread_service_principal" "kube_service" {
  application_id = var.aks_service_principal_app_id
}