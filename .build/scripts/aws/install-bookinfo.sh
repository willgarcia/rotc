#!/usr/bin/env bash

pwd 
# # 1. Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies
# kubectl label namespace default istio-injection=enabled

# # 2. Deploy the Bookinfo application
# kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
