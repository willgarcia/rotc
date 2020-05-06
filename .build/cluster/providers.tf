provider "google-beta" {
  version = "~> 2.13"
}

data "google_client_config" "current" {
  provider = "google-beta"
}

provider "null" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.3"
}

provider "helm" {
  version = "~> 1.1"
  kubernetes {
    config_path = "/root/.kube/config"
  }
}

provider "kubernetes" {
  version = "~> 1.11"
}
