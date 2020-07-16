resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_application_gateway.network.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.testIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.testIdentity, azurerm_application_gateway.network]
}
