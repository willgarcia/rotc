#! /usr/bin/env bash

BASEDIR=$(dirname "$0")
cd ${BASEDIR}

curl -sL https://git.io/getLatestIstio | sh -

cd istio*
export PATH=$PWD/bin:$PATH

test -x /usr/local/bin/istioctl || cp bin/istioctl /usr/local/bin/

echo "istioctl version"
istioctl version --remote=false