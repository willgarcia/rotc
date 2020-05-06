npm install
node webui.js
kubectl apply -f prometheus-app.yaml
kubectl get pods
kubectl port-forward $(kubectl get pod -l app=dockercoins -o jsonpath='{.items[0].metadata.name}') 3000:80
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') 9090:9090
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000
