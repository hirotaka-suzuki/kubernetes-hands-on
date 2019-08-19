variable "common" {
  type = "map"
  default = {
  }
}

## IP Address ranges ##
variable "cidr_ranges" {
  type = "map"
  default = {
  }
}

variable "vpc" {
  type = "map"
  default = {
  }
}

variable "gke" {
  type = "map"
  default = {
  }
}
  
variable "master_authorized_networks_config" {
  type = "list"
  default = [
  ]
}
