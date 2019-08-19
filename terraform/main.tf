module "hands_on_cluster" {
  source      = "./hands_on_cluster"
  common      = "${var.common}"
  cidr_ranges = "${var.cidr_ranges}"
  gke         = "${var.gke}"
  vpc         = "${var.vpc}"

  master_authorized_networks_config = "${var.master_authorized_networks_config}"
}
