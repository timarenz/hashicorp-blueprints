variable "gcp_project" {}

variable "gcp_region" {}

variable "environment_name" {}

variable "owner_name" {}

variable "consul_license" {}

variable "consul_version" {
  default = "1.9.0"
}

variable "consul_helm_version" {
  default = "0.27.0"
}

variable "consul_k8s_version" {
  default = "0.21.0"
}

variable "envoy_version" {
  default = "v1.16.0"
}

variable "consul_datacenter_name" {
  default = "k8s"
}
