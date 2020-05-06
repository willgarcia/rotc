#! /usr/bin/env bash

set -euo pipefail

# Upload Helm chart to our repo
HELM_REPO=servicemeshlab

ls ../03-k8s-deploy/03-03-helm/demo/dockercoins
helm package ../03-k8s-deploy/03-03-helm/demo/dockercoins
helm repo index . --url https://${HELM_REPO}-helm.storage.googleapis.com
gsutil cp dockercoins-0.1.0.tgz gs://${HELM_REPO}-helm
gsutil cp index.yaml gs://${HELM_REPO}-helm

helm repo add ${HELM_REPO} https://${HELM_REPO}-helm.storage.googleapis.com
helm repo update
