// https://hub.helm.sh/charts/stable/nginx-ingress
// https://github.com/helm/charts/tree/master/stable/nginx-ingress
data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "kubernetes_namespace" "nginx-ingress-ns" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx-ingress-chart" {
  name  = "nginx-ingress"
  chart = "stable/nginx-ingress"
  namespace = "nginx-ingress"

  depends_on = ["kubernetes_namespace.nginx-ingress-ns"]
}
