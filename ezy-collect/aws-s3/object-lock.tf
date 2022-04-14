resource "aws_s3_bucket_object_lock_configuration" "object_lock" {
    count = var.object_lock.enabled ? 1 : 0

    bucket = aws_s3_bucket.bucket.id
    
    rule {
        default_retention {
            mode = var.object_lock.mode
            days = var.object_lock.years != 0 ? null : var.object_lock.days
            years = var.object_lock.years == 0 ? null : var.object_lock.years
        }
    }
}