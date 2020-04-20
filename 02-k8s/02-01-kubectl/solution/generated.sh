set -eux

minikube start -p k8scluster
kubectl get componentstatus
kubectl cluster-info
kubectl proxy --port=8080
kubectl get nodes
kubectl get nodes -o json
kubectl get pods --all-namespaces
export TEAM_NAME=sandbox
kubectl create namespace ${TEAM_NAME} || true
kubectl get namespaces
kubectl config set-context --current --namespace=${TEAM_NAME}
kubectl get pods --all-namespaces -o wide
kubectl describe pod kube-apiserver-minikube -n kube-system
kubectl delete pod kube-apiserver-minikube -n kube-system
kubectl api-resources -o wide
kubectl explain [kind-name]
kubectl get pods --v 6
kubectl get pods --v 8
