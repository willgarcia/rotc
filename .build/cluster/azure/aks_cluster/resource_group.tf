

resource "azurerm_resource_group" "servicemesh_aks_cluster" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}
