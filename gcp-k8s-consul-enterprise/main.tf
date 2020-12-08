provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

data "google_client_config" "client" {}

resource "random_id" "consul_gossip_encryption_key" {
  byte_length = 32
}

resource "random_id" "uid" {
  byte_length = 3
  prefix      = "${var.owner_name}-"
}

locals {
  prefix           = "${random_id.uid.hex}-${var.environment_name}"
  consul_http_addr = "https://${data.kubernetes_service.consul_ui.load_balancer_ingress[0].ip}"
  bookinfo_fqdn    = "bookinfo.${data.kubernetes_service.consul_ingress_gateway.load_balancer_ingress[0].ip}.xip.io"
  bookinfo_url     = "http://${local.bookinfo_fqdn}:8080"
}

module "gcp" {
  source           = "git::https://github.com/timarenz/terraform-google-environment.git?ref=v0.2.4"
  region           = var.gcp_region
  project          = var.gcp_project
  environment_name = var.environment_name
  subnets = [{
    name   = "subnet-1"
    prefix = "192.168.40.0/24"
  }]
}
