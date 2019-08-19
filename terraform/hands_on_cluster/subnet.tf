resource "google_compute_subnetwork" "seg_hands_on_gke_node_01" {
  name          = "seg-hands-on-${var.common["user_prefix"]}-gke-node-01"
  project       = "${var.common["project"]}"
  ip_cidr_range = "${var.cidr_ranges["primary_gke_node_cidr_range"]}"
  region        = "${var.common["region"]}"
  network       = "${var.vpc["self_link"]}"

  enable_flow_logs = false

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "seg-hands-on-${var.common["user_prefix"]}-gke-service-01"
    ip_cidr_range = "${var.cidr_ranges["primary_gke_service_cidr_range"]}"
  }
  
  secondary_ip_range {
    range_name    = "seg-hands-on-${var.common["user_prefix"]}-gke-pod-01"
    ip_cidr_range = "${var.cidr_ranges["primary_gke_pod_cidr_range"]}"
  }
}

