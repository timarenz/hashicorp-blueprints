resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "kubernetes_secret" "consul" {
  metadata {
    name      = "consul"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  data = {
    license             = var.consul_license
    gossipEncryptionKey = random_id.consul_gossip_encryption_key.b64_std
  }
}

provider "helm" {
  kubernetes {
    host                   = module.k8s.endpoint
    cluster_ca_certificate = module.k8s.cluster_ca_certificate
    token                  = data.google_client_config.client.access_token

    load_config_file = false
  }
}

resource "helm_release" "consul" {
  name       = "consul"
  chart      = "consul"
  repository = "https://helm.releases.hashicorp.com"
  namespace  = kubernetes_namespace.consul.metadata[0].name
  version    = var.consul_helm_version
  values = [templatefile("${path.module}/templates/consul.yaml.tmpl",
    {
      consul_version         = var.consul_version,
      consul_k8s_version     = var.consul_k8s_version,
      envoy_version          = var.envoy_version
      consul_datacenter_name = var.consul_datacenter_name
  })]
}

data "kubernetes_secret" "consul_bootstrap_token" {
  depends_on = [helm_release.consul]
  metadata {
    name      = "consul-bootstrap-acl-token"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }
}

data "kubernetes_service" "consul_ui" {
  depends_on = [helm_release.consul]
  metadata {
    name      = "consul-ui"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }
}

data "kubernetes_service" "consul_ingress_gateway" {
  depends_on = [helm_release.consul]
  metadata {
    name      = "consul-ingress-gateway"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }
}

provider "consul" {
  address        = local.consul_http_addr
  scheme         = "https"
  insecure_https = true
  datacenter     = var.consul_datacenter_name
  token          = data.kubernetes_secret.consul_bootstrap_token.data.token
}

resource "consul_config_entry" "ingress_gateway" {
  depends_on = [helm_release.consul]
  name       = "ingress-gateway"
  kind       = "ingress-gateway"

  config_json = jsonencode({
    Listeners = [{
      Port     = 8080
      Protocol = "http"
      Services = [{
        Name      = "productpage"
        Hosts     = [local.bookinfo_fqdn]
        Namespace = "default"
      }]
    }]
  })
}
