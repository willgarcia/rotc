#!/usr/bin/env bash
RESOURCE_GROUP_NAME="pulumi-batect${AZURE_PREFIX}"
STORAGE_ACCOUNT_NAME="pulumi1${AZURE_PREFIX}"
STORAGE_CONTAINER_NAME="pulumi-backend"
end=$(date +"%Y-%m-%dT%H:%MZ" -d@"$(( `date  +%s`+86400))")

# Create resource group
az group create -l eastus -n $RESOURCE_GROUP_NAME

# Create storgae account
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l eastus --sku Standard_LRS --https-only --kind StorageV2

# Added sleep due to inconsistencies for how long it would take for the storage account to be available
sleep 5

# Create storage container
CONNECTION_STRING=$(az storage account show-connection-string -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -o tsv)  
az storage container create -n $STORAGE_CONTAINER_NAME --connection-string $CONNECTION_STRING

# Maybe not necessary?
sleep 5

# Create SAS Token to store cluster state in Azure
unset AZURE_STORAGE_SAS_TOKEN
SAS_TOKEN=$(az storage account generate-sas --permissions cdlruwap --account-name $STORAGE_ACCOUNT_NAME --services b --resource-types sco --expiry $end -o tsv)
export AZURE_STORAGE_SAS_TOKEN=$SAS_TOKEN
export AZURE_STORAGE_ACCOUNT=$STORAGE_ACCOUNT_NAME

# Same as above?
sleep 5

# Create new pulumi-k8s folder
cd cluster
mkdir pulumi-k8s && cd pulumi-k8s

# Login to azblob
pulumi login --cloud-url azblob://${STORAGE_CONTAINER_NAME}

# Create a new typescript pulumi project
pulumi new azure-typescript

# Copy files needed to spin up an AKS cluster
cp -r /code/cluster/azure-pulumi/. /code/cluster/pulumi-k8s

# Install dependencies
npm i

# Create an AKS cluster
pulumi up