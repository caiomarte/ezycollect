variable "cluster_ip" {
  description = "The IP address of the Kubernetes master."
  type = string
}

variable "sqs_endpoint" {
  description = "The endpoint of the SQS Queue."
  type = string
}

variable "s3_endpoint" {
  description = "The endpoint of the S3 Queue."
  type = string
}