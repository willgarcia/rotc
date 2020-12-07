// https://hub.helm.sh/charts/stable/nginx-ingress
// https://github.com/helm/charts/tree/master/stable/nginx-ingress
resource "kubernetes_namespace" "nginx-ingress-ns" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx-ingress-chart" {
  name  = "ingress-nginx"
  chart = "ingress-nginx"
  version = "2.11.1"
  repository = "https://kubernetes.github.io/ingress-nginx"

  namespace = kubernetes_namespace.nginx-ingress-ns.metadata.0.name
}
