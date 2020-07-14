#!/usr/bin/env bash

# Add the `stable` repo to helm
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Update helm
helm repo update

# Install prometheus
helm install --generate-name stable/grafana
