func init --docker
func new
export TEAM_NAME=sandbox
func kubernetes deploy \
    --name http-trigger \
    --namespace ${TEAM_NAME} \
    --registry k8straining.azurecr.io
kubectl get pod
kubectl get svc
# kubectl logs pod/[POD-NAME] http-trigger-http -f
kubectl delete all --all -n "${TEAM_NAME}"
