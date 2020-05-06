set -eux 

kubectl create secret generic my-secret --from-literal=password=helloWorld42+
kubectl apply -f secret-pod.yaml
kubectl logs pod/secret-app
kubectl delete all --all -n "${TEAM_NAME}"
kubectl delete secret my-secret