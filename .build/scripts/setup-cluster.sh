#! /usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_PATH/../.."

function main() {
  gcloud container clusters get-credentials k8s-cluster --region australia-southeast1 --project riseofthecontainerssydney

  runSetupForDirectory 02-02-k8s-app
  runSetupForDirectory 03-04-helm # This must run before 03-02, it contains the setup steps for installing Helm into the cluster.
  runSetupForDirectory 03-02-ingress
  runSetupForDirectory 03-06-pod-autoscaling
  runSetupForDirectory 04-01-service-mesh
  runSetupForDirectory 04-02-observability

  echoWhiteText "Cleaning up and preparing namespaces..."
  "$SCRIPT_PATH/scorch-earth.sh"

  echoWhiteText "Done!"
}

function runSetupForDirectory() {
  DIRECTORY=$1

  echoWhiteText "Performing setup for $DIRECTORY..."

  {
     cd "$ROOT_DIR/$DIRECTORY/.build"
     ./setup.sh
  }
}

function echoWhiteText() {
  TEXT=$1

  white=$(tput setaf 7)
  reset=$(tput sgr0)

  echo "$white$TEXT$reset"
}

main
