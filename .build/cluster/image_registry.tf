# See https://github.com/terraform-providers/terraform-provider-google/issues/4184 for an explanation of this.

resource "google_project_service" "container_registry" {
  provider = "google-beta"
  service = "containerregistry.googleapis.com"
}

resource "null_resource" "docker-registry" {
  provisioner "local-exec" {
    command = <<EOF
      docker-credential-gcr configure-docker && \
      (echo 'FROM scratch'; echo 'LABEL maintainer=binx.io') | \
      docker build -t gcr.io/${data.google_client_config.current.project}/scratch:latest - && \
      docker push gcr.io/${data.google_client_config.current.project}/scratch:latest
EOF
  }

  depends_on = [google_project_service.container_registry]
}

resource "google_storage_bucket_iam_binding" "registry_bucket_attendees_role_binding" {
  provider = "google-beta"
  role = "roles/storage.admin"
  bucket = "artifacts.${data.google_client_config.current.project}.appspot.com"

  members = local.attendees_as_gcp_identities

  depends_on = [
    null_resource.docker-registry
  ]
}

resource "google_storage_bucket_iam_binding" "registry_bucket_public_role_binding" {
  provider = "google-beta"
  role = "roles/storage.objectViewer"
  bucket = "artifacts.${data.google_client_config.current.project}.appspot.com"

  members = ["allUsers"]

  depends_on = [
    null_resource.docker-registry
  ]
}
