set -eux

kubectl delete -f hello-pod.yaml || true
kubectl apply -f hello-pod.yaml
wait 10
kubectl logs --follow pod/hello
kubectl apply -f dockercoins-pod.yaml
kubectl get events -w
kubectl get pods -o wide
minikube ssh -p k8scluster
curl [Pod-IP]
kubectl expose deployment dockercoins --type=LoadBalancer --port=80
minikube service dockercoins -p k8scluster
kubectl exec -it pod/[NAME] -- /bin/sh
kubectl exec -it pod/[NAME] -c [CONTAINER-NAME] -- /bin/sh
kompose convert
minikube stop -p k8scluster
minikube delete -p k8scluster
