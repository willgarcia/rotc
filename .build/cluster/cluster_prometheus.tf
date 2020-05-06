resource "kubernetes_namespace" "prometheus-ns" {
  metadata {
    name = "prometheus"
  }
}

resource "helm_release" "prometheus-chart" {
  name  = "prometheus"
  chart = "stable/prometheus"
  namespace = "prometheus"

  depends_on = ["kubernetes_namespace.prometheus-ns"]
}
