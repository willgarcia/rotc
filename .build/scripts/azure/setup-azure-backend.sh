#!/usr/bin/env bash
RESOURCE_GROUP_NAME=terraform-service-mesh
STORAGE_ACCOUNT_NAME="${TF_VAR_prefix}stgterra1"
STORAGE_CONTAINER_NAME=tfstate

# Create resource group
az group create -l eastus -n $RESOURCE_GROUP_NAME

# Create storage account
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l eastus --sku Standard_LRS --https-only --kind StorageV2

sleep 5

# Create storage container
CONNECTION_STRING=$(az storage account show-connection-string -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -o tsv)  
az storage container create -n $STORAGE_CONTAINER_NAME --connection-string $CONNECTION_STRING
