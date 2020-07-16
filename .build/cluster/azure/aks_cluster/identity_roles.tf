resource "azurerm_role_assignment" "ra2" {
  scope                = azurerm_user_assigned_identity.testIdentity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_service_principal_object_id
  depends_on           = [azurerm_user_assigned_identity.testIdentity]
}