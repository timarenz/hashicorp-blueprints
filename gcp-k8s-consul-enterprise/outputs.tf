output "useful_commands" {
  value = <<EOF

-------------------------------------------------------------------------------------
Useful commands:

# Set K8S-1 config for kubectl
export KUBECONFIG="${local_file.kubeconfig.filename}"

# Get Consul bootstrap token 
kubectl -n consul get secret consul-bootstrap-acl-token -o jsonpath="{.data.token}" | base64 -d

# Port-forward Consul API / UI
kubectl -n consul port-forward consul-server-0 8501

# Configure Consul CLI
export CONSUL_HTTP_ADDR=${local.consul_http_addr}
export CONSUL_HTTP_SSL_VERIFY=false
export CONSUL_HTTP_TOKEN=${data.kubernetes_secret.consul_bootstrap_token.data.token}
-------------------------------------------------------------------------------------
EOF
}

output "consul_bootstrap_token" {
  value = data.kubernetes_secret.consul_bootstrap_token.data.token
  # sensitive = true
}

output "consul_ingress_gateway_public_ip" {
  value = data.kubernetes_service.consul_ingress_gateway.load_balancer_ingress[0].ip
}

output "consul_http_addr" {
  value = local.consul_http_addr
}

output "bookinfo_url" {
  value = local.bookinfo_url
}