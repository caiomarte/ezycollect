locals {
  values = {
    sqs = var.sqs_endpoint
    s3 = var.s3_endpoint
    manager   = "terraform"
  }
}


resource "helm_release" "nginx" {
  name             = "nginx"
  description      = "Helm Chart release for the nginx:1.21.6-alpine image."
  chart            = "./nginx/helm"
  namespace        = "nginx-namespace"
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
