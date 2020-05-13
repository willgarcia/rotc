resource "google_storage_bucket" "helm_repo" {
  provider = "google-beta"

  name = "${data.google_client_config.current.project}-helm"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "helm_repo_bucket_role_binding" {
  provider = "google-beta"
  role = "roles/storage.objectViewer"
  bucket = google_storage_bucket.helm_repo.name

  members = ["allUsers"]

  depends_on = [
    null_resource.docker-registry
  ]
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}
