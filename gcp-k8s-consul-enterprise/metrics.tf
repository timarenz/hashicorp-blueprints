resource "kubernetes_namespace" "metrics" {
  metadata {
    name = "metrics"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = kubernetes_namespace.metrics.metadata[0].name
  version    = "11.7.0"
  values     = [file("${path.module}/files/prometheus.yaml")]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = kubernetes_namespace.metrics.metadata[0].name
  version    = "5.3.6"
  values     = [file("${path.module}/files/grafana.yaml")]
}

resource "kubectl_manifest" "statsd-exporter" {
    yaml_body = file("${path.module}/files/statsd-exporter.yaml")
}