output "endpoint" {
    description = "The endpoint of the S3 bucket."
    value = aws_s3_bucket.bucket.bucket_domain_name
}