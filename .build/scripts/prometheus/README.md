# Prometheus

## GKE

The scripts under `.build/scripts/prometheus/gke/prometheus-stackdriver.sh` are used by the batect task `./batect setup-cluster` to:

* to install prometheus
* add a Stackdriver sidecar to prometheus, so that metrics can be viewed in the GCP console>Stackdriver

The compatibility matrix available at <https://github.com/Stackdriver/stackdriver-prometheus-sidecar#compatibility> shows the compatible/tested versions of Stackdriver sidecar with Prometheus.
