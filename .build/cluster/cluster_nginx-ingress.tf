// https://hub.helm.sh/charts/stable/nginx-ingress
// https://github.com/helm/charts/tree/master/stable/nginx-ingress
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
