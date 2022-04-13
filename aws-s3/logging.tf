locals {
    target_grants = var.sysadmin_group != "" ? [{
        permission = "READ"
        uri = var.sysadmin_group
        type = "Group"
    }] : null
}

resource "aws_s3_bucket_logging" "logging" {
    bucket = aws_s3_bucket.bucket.id
    target_bucket = var.logging_bucket == "" ? aws_s3_bucket.bucket.id : var.logging_bucket
    target_prefix = aws_s3_bucket.bucket.id

    dynamic "target_grant" {
        for_each = local.target_grants
        content {
            permission = target_grant.value["permission"]
            grantee {
                uri = target_grant.value["uri"]
                type = target_grant.value["type"]
            }
        }
    }
}