data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  depends_on = [azurerm_resource_group.servicemesh_aks_cluster]
}
