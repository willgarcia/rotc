# see .build/prometheus for the last part of the prometheus setup

resource "kubernetes_namespace" "prometheus-ns" {
  metadata {
    name = "prometheus"
  }
}
