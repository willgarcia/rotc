// https://cloud.google.com/community/tutorials/visualizing-metrics-with-grafana
resource "kubernetes_namespace" "grafana-ns" {
  metadata {
    name = "grafana"
  }
}

resource "helm_release" "grafana-chart" {
  name  = "grafana"
  chart = "stable/grafana"
  namespace = "grafana"

  depends_on = ["kubernetes_namespace.grafana-ns"]
}
