#!/usr/bin/env bash
RESOURCE_GROUP_NAME=terraform-service-mesh

az group delete -n $RESOURCE_GROUP_NAME -y
az group delete -n NetworkWatcherRG -y