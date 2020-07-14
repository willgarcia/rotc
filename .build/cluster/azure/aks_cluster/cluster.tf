resource "azurerm_kubernetes_cluster" "servicemesh_aks_cluster" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.servicemesh_aks_cluster.location
  resource_group_name = azurerm_resource_group.servicemesh_aks_cluster.name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled = false
    }
  }
}