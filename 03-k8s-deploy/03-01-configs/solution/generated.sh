set -eux 

kubectl apply -f config-map.yaml
kubectl apply -f config-pod.yaml
kubectl logs pod/app
