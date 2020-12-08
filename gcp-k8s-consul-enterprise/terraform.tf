terraform {
  required_version = ">= 0.14.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.49.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 1.3.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13.3"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.9.4"
    }
  }
  backend "remote" {
    organization = "timarenz"

    workspaces {
      name = "gcp-k8s-consul-enterprise"
    }
  }
}
