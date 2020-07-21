
resource "azurerm_role_assignment" "ra1" {
  scope                = azurerm_subnet.kubesubnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.kube_service.object_id

  depends_on = [azurerm_virtual_network.test]
}