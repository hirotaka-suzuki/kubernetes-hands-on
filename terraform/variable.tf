variable "common" {
  type = "map"
  default = {
    "project"          = ""
    "region"           = "asia-northeast1"
    "primary_zone"     = "asia-northeast1-a"
    "secondary_zone"   = "asia-northeast1-b"
    "tertiary_zone"    = "asia-northeast1-c"
    "env_prefix"       = "sandbox"
    "env_prefix_full"  = "sandbox"
    "username"         = ""
    "user_prefix"      = ""
  }
}

## IP Address ranges ##
variable "cidr_ranges" {
  type = "map"
  default = {
    "primary_gke_master_address_cidr_range" = "10.192.240.0/28"

    "primary_gke_node_cidr_range"           = "10.192.0.0/22"
    "primary_gke_service_cidr_range"        = "10.192.4.0/22"
    "primary_gke_pod_cidr_range"            = "10.192.8.0/21"
  }
}

variable "vpc" {
  type = "map"
  default = {
    "name"      = ""
    "self_link" = ""
  }
}

variable "gke" {
  type = "map"
  default = {
    "k8s_version" = "1.13.7-gke.8"
  }
}
  
variable "master_authorized_networks_config" {
  type = "list"
  default = [
    {
      cidr_block   = ""
      display_name = ""
    },
  ]
}
