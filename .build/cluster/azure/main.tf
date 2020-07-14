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
    resource_group_name = "${var.prefix}-k8s-resources"

    aks_service_principal_app_id = "<Service Principal AppId>"

    aks_service_principal_client_secret = "<Service Principal Client Secret>"

    aks_service_principal_object_id = "<Service Principal Object Id>"    
}