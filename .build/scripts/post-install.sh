#! /usr/bin/env bash

set -euo pipefail

# Build and push v2 image of webui (earlier versions are done as part of setup for 02-02
DOCKER_REPO=rotcaus
cd ../04-observability/04-01-prometheus/exercise/webui
docker build . -t ${DOCKER_REPO}/dockercoins_webui:v2
docker push ${DOCKER_REPO}/dockercoins_webui:v2
cd -

# Upload Helm chart to our repo
HELM_REPO=servicemeshlab

ls ../03-k8s-deploy/03-03-helm/demo/dockercoins
helm package ../03-k8s-deploy/03-03-helm/demo/dockercoins
helm repo index . --url https://${HELM_REPO}-helm.storage.googleapis.com
gsutil cp dockercoins-0.1.0.tgz gs://${HELM_REPO}-helm
gsutil cp index.yaml gs://${HELM_REPO}-helm

helm repo add ${HELM_REPO} https://${HELM_REPO}-helm.storage.googleapis.com
helm repo update
