#!/usr/bin/env bash

# echo "Istio version"
istioctl version --remote=false
ISTIO_VERSION="$(istioctl version --remote=false)"

# 1. Create a kubeconfig for Amazon EKS and verify configuration
# aws eks --region us-east-1 update-kubeconfig --name servicemesh_eks_cluster

# 2. Install Istio in the istio-system namespace
echo "Istio pre-installation verification"
istioctl verify-install
istioctl manifest apply --set profile=demo

# 3. Verify the services are deployed
kubectl -n istio-system get svc

# # 4. Verify Pods
kubectl -n istio-system get pods

# 5. Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies
kubectl label namespace default istio-injection=enabled

# 6. Deploy the Bookinfo application
kubectl apply -f "../istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/bookinfo.yaml"

# 7. Verify Bookinfo is deployed
echo "Verifying deployment"
kubectl get svc
kubectl get pods

# 8. Verify everything is working so far. Check if the app is running inside the cluster and serving HTML pages by checking for the page title in the response:
kubectl exec -it $(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}') -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"

# 9. Open the application to outside traffic
echo "Opening to outside traffic"
kubectl apply -f "../istio-$ISTIO_VERSION/samples/bookinfo/networking/bookinfo-gateway.yaml"
istioctl analyze

# 10. Set the ingress ports
echo "Setting ingress ports"
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

# 11. Apply default destination rules
echo "Applying default destination rules"
kubectl apply -f "../istio-$ISTIO_VERSION/samples/bookinfo/networking/destination-rule-all.yaml"

# 12. Get browser address
echo "Copy this address into your browser to view the Bookinfo product page:"
echo http://$GATEWAY_URL/productpage