data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "kubernetes_namespace" "cert-manager-ns" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name  = "cert-manager"
  chart = "jetstack/cert-manager"
  namespace = "cert-manager"

  depends_on = ["kubernetes_namespace.cert-manager-ns"]
}
