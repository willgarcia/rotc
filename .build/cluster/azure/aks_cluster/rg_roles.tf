resource "azurerm_role_assignment" "ra4" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.testIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.testIdentity, azurerm_application_gateway.network]
}