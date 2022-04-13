resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
    object_lock_enabled = var.object_lock.enabled
}