#!/usr/bin/env bash

curl -sL https://git.io/getLatestIstio | sh -
cd istio*

export PATH=$PWD/bin:$PATH
echo $PATH

test -x /usr/local/bin/istioctl || cp bin/istioctl /usr/local/bin/

echo "Istio version"
istioctl version --remote=false

# 1. Create a kubeconfig for Amazon EKS and verify configuration
aws eks --region us-east-1 update-kubeconfig --name servicemesh_eks_cluster

# 2. Install Istio in the istio-system namespace
echo "Istio pre-installation verification"
istioctl verify-install
istioctl manifest apply --set profile=demo

# 3. Verify the services are deployed
kubectl -n istio-system get svc

# 4. Verify Pods
kubectl -n istio-system get pods