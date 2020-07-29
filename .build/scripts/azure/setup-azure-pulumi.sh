#!/usr/bin/env bash
RESOURCE_GROUP_NAME="pulumi-batect${AZURE_PREFIX}"
STORAGE_ACCOUNT_NAME="pulumi1${AZURE_PREFIX}"
STORAGE_CONTAINER_NAME="pulumi-backend"
# end=`date -v+30M '+%Y-%m-%dT%H:%MZ'`
end=$(date +"%Y-%m-%dT%H:%MZ" -d@"$(( `date  +%s`+86400))")


az group create -l eastus -n $RESOURCE_GROUP_NAME

az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l eastus --sku Standard_LRS --https-only --kind StorageV2

sleep 5

CONNECTION_STRING=$(az storage account show-connection-string -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -o tsv)  

az storage container create -n $STORAGE_CONTAINER_NAME --connection-string $CONNECTION_STRING

sleep 10

sleep 5

# pulumi login --cloud-url azblob://${STORAGE_CONTAINER_NAME}
unset AZURE_STORAGE_SAS_TOKEN

SAS_TOKEN=$(az storage account generate-sas --permissions cdlruwap --account-name $STORAGE_ACCOUNT_NAME --services b --resource-types sco --expiry $end -o tsv)
# az storage account generate-sas --permissions cdlruwap --account-name $AZURE_STORAGE_ACCOUNT --services b --resource-types sco --expiry $end -o tsv
export AZURE_STORAGE_SAS_TOKEN=$SAS_TOKEN
export AZURE_STORAGE_ACCOUNT=$STORAGE_ACCOUNT_NAME

sleep 5

cd cluster

mkdir pulumi-test && cd pulumi-test

pulumi login --cloud-url azblob://${STORAGE_CONTAINER_NAME}

pulumi new azure-typescript

cp -r /code/cluster/azure-pulumi/. /code/cluster/pulumi-test

npm i

pulumi preview --logtostderr -v 7

export PULUMI_ENABLE_LEGACY_PLUGIN_SEARCH=1

pulumi up