#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TERRAFORM_DIR="${SCRIPT_DIR}/../cluster"
STATE_BUCKET_NAME="${CLOUDSDK_CORE_PROJECT}-terraform-state"

function main {
    echo "Checking project..."
    if ! projectExists; then
        createProject
    fi

    echo "Checking state bucket..."
    if ! stateBucketExists; then
        createStateBucket
    fi

    runTerraformInit
}

function projectExists {
    ! gcloud projects list --filter "$CLOUDSDK_CORE_PROJECT" 2>&1 | grep -q 'Listed 0 items.'
}

function createProject {
    echo "Project does not exist, creating it..."
    gcloud projects create "$CLOUDSDK_CORE_PROJECT"
    gcloud beta billing projects link "$CLOUDSDK_CORE_PROJECT" --billing-account="$GOOGLE_BILLING_ACCOUNT_ID"
}

function stateBucketExists {
    gsutil ls -b "gs://$STATE_BUCKET_NAME" >/dev/null 2>&1
}

function createStateBucket {
    echo "State bucket does not exist, creating it..."
    gsutil mb -c regional -l $CLOUDSDK_COMPUTE_REGION "gs://$STATE_BUCKET_NAME"
}

function runTerraformInit {
    terraform init -input=false -reconfigure -backend-config="bucket=$STATE_BUCKET_NAME" "$TERRAFORM_DIR"
}

main
