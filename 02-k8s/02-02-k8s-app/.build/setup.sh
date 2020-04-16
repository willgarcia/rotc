#! /usr/bin/env bash

set -euo pipefail

REGISTRY=gcr.io/rotcaus

function dockerTag() {
    LOCAL_IMAGE=$1
    REMOTE_IMAGE=$2
    docker rmi -f ${REGISTRY}/${REMOTE_IMAGE}:v1 || true
    docker tag ${LOCAL_IMAGE} ${REGISTRY}/${REMOTE_IMAGE}:v1
    docker push ${REGISTRY}/${REMOTE_IMAGE}:v1
}

docker-compose build

dockerTag "build_webui" "dockercoins_webui"
dockerTag "build_worker" "dockercoins_worker"
dockerTag "build_hasher" "dockercoins_hasher"
dockerTag "build_rng" "dockercoins_rng"
