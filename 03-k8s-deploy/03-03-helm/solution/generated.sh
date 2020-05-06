set -eux

helm search metabase
helm fetch --untar stable/metabase
cd metabase
helm dep list
# help dep update
helm install stable/metabase
helm ls
export TEAM_NAME=sandbox
export POD_NAME=$(kubectl get pods --namespace ${TEAM_NAME} -l "app=metabase,release=my-release" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace ${TEAM_NAME} $POD_NAME 8080:3000
kubectl delete all --all -n "${TEAM_NAME}"
helm delete $(helm ls --namespace $TEAM_NAME --short)
