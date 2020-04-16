#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function main() {
  resetAttendeeNamespaces
  resetReservedNamespaces

  kubectl config set-context --current --namespace=default

  echo "Done!"
}

function resetAttendeeNamespaces() {
  attendees=$(cat "$SCRIPT_DIR/../attendees.txt")

  for attendee in $attendees; do
    username=$(echo ${attendee%%@*} | tr . -)
    echoBlueText "Resetting namespace for $attendee ($username)..."

    scorchEarth $username
  done
}

function resetReservedNamespaces() {
  scorchEarth sandbox
  scorchEarth team-trainers
  scorchEarth bookinfo-demo
  scorchEarth microservices-demo
  scorchEarth voting
}

function scorchEarth() {
  NAMESPACE=$1
  echo "Cleaning up namespace $NAMESPACE..."

  kubectl delete all --all -n $NAMESPACE
  helm delete --purge $(helm ls --namespace $NAMESPACE --short) || true
  kubectl delete namespace $NAMESPACE || true
  kubectl create namespace $NAMESPACE
  kubectl label namespace $NAMESPACE istio-injection=enabled
}

function echoBlueText() {
  TEXT=$1

  white=$(tput setaf 4)
  reset=$(tput sgr0)

  echo "$white$TEXT$reset"
}

main
