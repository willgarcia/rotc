provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you are using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name = "terraform-service-mesh"
        # storage_account_name = provide as a backend config variable
        container_name = "tfstate"
        key = "dev"
    }
}

module "aks_cluster" {
    source = "./aks_cluster"
    location = var.location
    prefix = var.prefix
    aks_dns_prefix = "${var.prefix}-aks"
    resource_group_name = "${var.prefix}-k8s-resources"

    # AKS only supports either SystemAssigned or ServicePrinicpal identity
    # So - since we're using an app gateway, we need to provide these
    aks_service_principal_app_id = var.aks_service_principal_app_id
    aks_service_principal_client_secret = var.aks_service_principal_client_secret
    aks_service_principal_object_id = var.aks_service_principal_object_id 
}