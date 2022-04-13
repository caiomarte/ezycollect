resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.bucket.id

    rule {
        bucket_key_enabled = true

        apply_server_side_encryption_by_default {
            sse_algorithm = "aws:kms"
        }
    }
}