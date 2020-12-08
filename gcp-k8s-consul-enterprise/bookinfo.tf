data "kubectl_file_documents" "bookinfo" {
  content = file("${path.module}/files/bookinfo/bookinfo.yaml")
}

resource "kubectl_manifest" "bookinfo" {
  depends_on = [helm_release.consul]
  count      = length(data.kubectl_file_documents.bookinfo.documents)
  yaml_body  = element(data.kubectl_file_documents.bookinfo.documents, count.index)
}

data "kubectl_file_documents" "intentions_bookinfo" {
  content = file("${path.module}/files/bookinfo/intentions-bookinfo.yaml")
}

resource "kubectl_manifest" "intentions_bookinfo" {
  depends_on = [helm_release.consul]
  count      = length(data.kubectl_file_documents.intentions_bookinfo.documents)
  yaml_body  = element(data.kubectl_file_documents.intentions_bookinfo.documents, count.index)
}

resource "kubectl_manifest" "intentions_ingress" {
  depends_on = [helm_release.consul]
  yaml_body  = file("${path.module}/files/bookinfo/intentions-ingress.yaml")
}
