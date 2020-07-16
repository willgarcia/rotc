

resource "azurerm_resource_group" "servicemesh_aks_cluster" {
  name     = "${var.resource_group_name}"
  location = var.location
}
