variable "kubernetes_version" {
  default = "1.15.11-gke.5"
}

resource "google_compute_subnetwork" "network-with-ip-ranges" {
  name          = "default"
  ip_cidr_range = "10.0.0.0/24"
  region        = "australia-southeast1"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_network" "vpc_network" {
  name = "default"
  auto_create_subnetworks = false
}

resource "google_project_service" "kubernetes_service" {
  provider = "google-beta"

  project = data.google_client_config.current.project
  service = "container.googleapis.com"
  disable_dependent_services = false
}

resource "google_container_cluster" "cluster" {
  provider = "google-beta"

  depends_on = [google_project_service.kubernetes_service]

  name = "k8s-cluster"
  location = "australia-southeast1"

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  min_master_version = var.kubernetes_version
  node_version = var.kubernetes_version

  network = google_compute_network.vpc_network.self_link

  master_auth {
    // Disable basic authentication.
    password = ""
    username = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }
  }

  remove_default_node_pool = true
  initial_node_count = 1

  ip_allocation_policy {
    create_subnetwork = true
  }
}

resource "google_container_node_pool" "node_pool" {
  name = "default-node-pool"
  provider = "google-beta"
  cluster = google_container_cluster.cluster.name
  location = google_container_cluster.cluster.location

  // This is per zone, so the cluster will have number of zones (eg. 3) x node_count nodes
  node_count = 1

  version = var.kubernetes_version

  node_config {
    machine_type = "n1-standard-2"
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }
}

# Warning: this grants all attendees the container.developer role for all GKE clusters in the
# current project. You should only use this with a GCP project set up solely for the workshop.
resource "google_project_iam_binding" "cluster_binding" {
  provider = "google-beta"

  project = data.google_client_config.current.project
  role = "roles/container.developer"

  members = local.attendees_as_gcp_identities
}
