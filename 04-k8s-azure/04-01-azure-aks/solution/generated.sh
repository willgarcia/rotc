set -eux

az aks get-credentials --name k8straining-aks --resource-group k8straining
kubectl config get-contexts
az aks browse --resource-group k8straining --name k8straining-aks
export TEAM_NAME=sandbox
kubectl config set-context --current --namespace=${TEAM_NAME}
kubectl config get-contexts
