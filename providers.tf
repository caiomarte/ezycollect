terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.7"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">=1.14.0"
    }
  }

  backend "s3" {
    bucket      = "bucket-backend"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region      = "ap-southeast-2"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

provider "kubernetes" {
  host  = local.cluster_endpoint
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", local.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host  = local.cluster_endpoint
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", local.cluster_name]
    }
  }
}
