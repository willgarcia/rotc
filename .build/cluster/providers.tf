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