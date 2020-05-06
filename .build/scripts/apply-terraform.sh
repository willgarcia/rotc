#! /usr/bin/env bash

set -euo pipefail

terraform plan \
    -input=false \
    -var=cluster_location=${CLUSTER_LOCATION} \
    -var=cluster_name=${CLUSTER_NAME} \
    -var=cluster_version=${CLUSTER_VERSION} \
    -var=subnet_region=${CLOUDSDK_COMPUTE_REGION} \
    -out tf.plan \
    cluster

terraform apply \
    -input=false \
    -auto-approve tf.plan
