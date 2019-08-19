provider "google" {
  version = "2.13.0"

  project = "${var.common["project"]}"
  region  = "${var.common["region"]}"
}

provider "google-beta" {
  version = " 2.13.0"

  project = "${var.common["project"]}"
  region  = "${var.common["region"]}"
}
