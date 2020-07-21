# data "azurerm_subnet" "kubesubnet" {
#   name                 = var.aks_subnet_name
#   virtual_network_name = azurerm_virtual_network.test.name
#   resource_group_name  = data.azurerm_resource_group.rg.name
#   depends_on = [azurerm_virtual_network.test]

# }

# data "azurerm_subnet" "appgwsubnet" {
#   name                 = "appgwsubnet"
#   virtual_network_name = azurerm_virtual_network.test.name
#   resource_group_name  = data.azurerm_resource_group.rg.name
#   depends_on = [azurerm_virtual_network.test]
# }

resource "azurerm_subnet" "kubesubnet" {

    name           = var.aks_subnet_name
    resource_group_name  = data.azurerm_resource_group.rg.name

    virtual_network_name = azurerm_virtual_network.test.name
    address_prefixes = [var.aks_subnet_address_prefix]
  }

resource "azurerm_subnet" "appgwsubnet" {
    name           = "appgwsubnet"

    resource_group_name  = data.azurerm_resource_group.rg.name

    virtual_network_name = azurerm_virtual_network.test.name

    address_prefixes = [var.app_gateway_subnet_address_prefix]
  }
