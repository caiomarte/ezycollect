resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
    bucket = aws_s3_bucket.bucket.id

    rule {
        id = "${aws_s3_bucket.bucket.id}-lifecycle-rule"
        status = "Enabled"

        filter {
            tag {
                key = "lifecycle"
                value = "managed"
            }
        }

        expiration {
            days = 90
        }

        transition {
            storage_class = "INTELLIGENT_TIERING"
            days = 90
        }

        abort_incomplete_multipart_upload {
            days_after_initiation = 30
        }

        noncurrent_version_expiration {
            newer_noncurrent_versions = 2
            noncurrent_days = 90
        }

        noncurrent_version_transition {
            storage_class = "STANDARD_IA"
            newer_noncurrent_versions = 10
            noncurrent_days = 90
        }
    }
}