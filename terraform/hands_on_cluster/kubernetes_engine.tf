resource "google_container_cluster" "hands_on_cluster_01" {
  provider = "google-beta"

  name                        = "${var.common["env_prefix"]}-${var.common["user_prefix"]}-cluster-01"
  project                     = "${var.common["project"]}"
  location                    = "${var.common["region"]}"
  network                     = "${var.vpc["self_link"]}"
  subnetwork                  = "${replace("${google_compute_subnetwork.seg_hands_on_gke_node_01.self_link}", "https://www.googleapis.com/compute/v1/", "")}"
  cluster_ipv4_cidr           = "${var.cidr_ranges["primary_gke_pod_cidr_range"]}"
  min_master_version          = "${var.gke["k8s_version"]}"
  default_max_pods_per_node   = 32
  enable_binary_authorization = false
  enable_kubernetes_alpha     = false
  enable_legacy_abac          = false
  enable_tpu                  = false
  logging_service             = "logging.googleapis.com/kubernetes"
  monitoring_service          = "monitoring.googleapis.com/kubernetes"

  cluster_autoscaling {
    # Beta: Node pool auto provisioing option. See, https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-provisioning
    enabled = false
  }
  
  ip_allocation_policy {
    cluster_secondary_range_name  = "seg-hands-on-${var.common["user_prefix"]}-gke-pod-01"
    services_secondary_range_name = "seg-hands-on-${var.common["user_prefix"]}-gke-service-01"
    use_ip_aliases                = true
  }
  
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "${var.cidr_ranges["primary_gke_master_address_cidr_range"]}"
  }
  
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = "${var.master_authorized_networks_config}"
      content {
        cidr_block = "${lookup("${cidr_blocks.value}", "cidr_block", null)}"
        display_name = "${lookup("${cidr_blocks.value}", "display_name", null)}"
      }
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  
  node_locations = [
    "${var.common["primary_zone"]}",
    "${var.common["secondary_zone"]}",
    "${var.common["tertiary_zone"]}",
  ]

  node_pool {
    name               = "${var.common["env_prefix"]}-${var.common["user_prefix"]}-pool-01-v${replace(var.gke["k8s_version"], "/\\./", "-")}"
    max_pods_per_node  = 32
    initial_node_count = 1
    version            = "${var.gke["k8s_version"]}"

    management {
      auto_repair  = true
      auto_upgrade = false
    }
   
    node_config {
      preemptible     = true
      local_ssd_count = 0
      machine_type    = "n1-standard-1"
      disk_size_gb    = 20
      disk_type       = "pd-ssd"
      image_type      = "COS"

      labels = {
        name    = "${var.common["env_prefix"]}-${var.common["user_prefix"]}-pool-01"
        product = "hands-on"
      }

      metadata = {
        disable-legacy-endpoints = "1"
      }
      
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management",
        "https://www.googleapis.com/auth/servicecontrol",
      ]
    }
  }

  addons_config {
    cloudrun_config            { disabled = true }
    horizontal_pod_autoscaling { disabled = false }
    http_load_balancing        { disabled = false }
    istio_config               { disabled = true }
    kubernetes_dashboard       { disabled = true }
    network_policy_config      { disabled = false }
  }
  
  resource_labels = {
    name    = "${var.common["env_prefix"]}-${var.common["user_prefix"]}-cluster-01"
    product = "hands-on"
  }
}
