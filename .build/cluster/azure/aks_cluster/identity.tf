# User Assigned Identities
resource "azurerm_user_assigned_identity" "testIdentity" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  name = "identity1"

  tags = var.tags
  lifecycle {
    ignore_changes = [
      "location"
    ]
  }    
}

