# Prometheus

# GKE

The scripts under `.build/prometheus/gke` are used by the batect task `` to:
- to install prometheus
- add a Stackdriver sidecar to prometheus, so that metrics can be viewed in the GCP console>Stackdriver

bash ./prometheus-stackdriver.sh deployment prometheus-deployment

kubectl port-forward prometheus-deployment-66ff565bbc-4lxpj 8080:9090 -n prometheus

https://github.com/Stackdriver/stackdriver-prometheus-sidecar#compatibility

https://console.cloud.google.com/gcr/images/stackdriver-prometheus/GLOBAL/stackdriver-prometheus-sidecar?gcrImageListsize=30&gcrImageListquery=%255B%255D