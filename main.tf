locals {
    cluster_name = "cluster"
    cluster_ip = "35.187.14.109"
    cluster_endpoint = "https://${var.cluster_ip}:80"
    cluster_ca_certificate = base64decode("certificate.b64")
}

module "sqs" {
    source = "./aws-sqs"
    # Using variable defaults
}

module "s3" {
    source = "./aws-s3"
    # Using variable defaults
}

module "nginx" {
    source = "./nginx"

    cluster_ip = local.cluster_ip
    sqs_endpoint = module.sqs.endpoint
    s3_endpoint = module.s3.endpoint
}