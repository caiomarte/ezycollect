locals {
  values = {
    name      = var.application.image
    image     = var.application.image
    version   = var.application.version
    namespace = "${var.application.image}-namespace"
    replicas  = var.application.replicas
    port      = var.application.port
    address   = var.cluster_ip
    domain    = var.application.domain
    sqs = var.sqs_endpoint
    s3 = var.s3_endpoint
    manager   = "terraform"
    author    = "caio-martinho"
  }
}


resource "helm_release" "nginx" {
  name             = local.values["name"]
  description      = "Helm Chart release for the ${local.values["image"]}:${local.values["version"]} image."
  chart            = "./nginx/helm"
  namespace        = local.values["namespace"]
  create_namespace = true
  reset_values     = true
  cleanup_on_fail  = true
  atomic           = true

  dynamic "set" {
    for_each = local.values
    content {
      name  = set.key
      value = set.value
    }
  }
}
