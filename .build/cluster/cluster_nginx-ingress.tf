// https://hub.helm.sh/charts/stable/nginx-ingress
// https://github.com/helm/charts/tree/master/stable/nginx-ingress
resource "kubernetes_namespace" "nginx-ingress-ns" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx-ingress-chart" {
  name  = "nginx-ingress"
  chart = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"

  namespace = kubernetes_namespace.nginx-ingress-ns.metadata.0.name
}
