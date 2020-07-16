resource "azurerm_virtual_network" "test" {
  name                = var.virtual_network_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name           = var.aks_subnet_name
    address_prefix = var.aks_subnet_address_prefix
  }

  subnet {
    name           = "appgwsubnet"
    address_prefix = var.app_gateway_subnet_address_prefix
  }

  tags = var.tags
}

