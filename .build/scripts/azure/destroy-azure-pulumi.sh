#!/usr/bin/env bash
RESOURCE_GROUP_NAME="pulumi-batect${AZURE_PREFIX}"
STORAGE_ACCOUNT_NAME="pulumi1${AZURE_PREFIX}"
STORAGE_CONTAINER_NAME="pulumi-backend"
end=$(date +"%Y-%m-%dT%H:%MZ" -d@"$(( `date  +%s`+86400))")


# Create SAS Token to access blob in Azure
unset AZURE_STORAGE_SAS_TOKEN
SAS_TOKEN=$(az storage account generate-sas --permissions cdlruwap --account-name $STORAGE_ACCOUNT_NAME --services b --resource-types sco --expiry $end -o tsv)
export AZURE_STORAGE_SAS_TOKEN=$SAS_TOKEN
export AZURE_STORAGE_ACCOUNT=$STORAGE_ACCOUNT_NAME


# Login to azblob where k8s state is held
cd cluster/pulumi-k8s
pulumi login --cloud-url azblob://${STORAGE_CONTAINER_NAME}

# install kubernetes plugin 
pulumi plugin install resource kubernetes 2.4.1

# destroy stack
pulumi destroy

# clean up remaining resource groups
az group delete -n $RESOURCE_GROUP_NAME -y
az group delete -n NetworkWatcherRG -y

# remove folder pulumi-k8s folder
cd ..
rm -rf pulumi-k8s
