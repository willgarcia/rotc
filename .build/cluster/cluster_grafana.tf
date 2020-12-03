// https://cloud.google.com/community/tutorials/visualizing-metrics-with-grafana
resource "kubernetes_namespace" "grafana-ns" {
  metadata {
    name = "grafana"
  }
}

resource "helm_release" "grafana-chart" {
  name  = "grafana"
  chart = "grafana"
  repository = "https://grafana.github.io/helm-charts"

  namespace = kubernetes_namespace.grafana-ns.metadata.0.name
}
