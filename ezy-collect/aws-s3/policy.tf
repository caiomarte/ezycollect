resource "aws_s3_bucket_policy" "policy" {
    count = var.cloudfront_distribution.enabled ? 1 : 0

    bucket = aws_s3_bucket.bucket.id
    policy = data.aws_iam_policy_document.policy[0].json
}

data "aws_iam_policy_document" "policy" {
    count = var.cloudfront_distribution.enabled ? 1 : 0

    version = "2012-10-17"
    id = "PolicyForCloudFrontPrivateContent"
    
    statement {
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [
                "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.cloudfront_distribution.oai}"
            ]
        }
        actions = [
            "s3:GetObject"
        ]
        resources = [
            aws_s3_bucket.bucket.arn,
            "${aws_s3_bucket.bucket.arn}/*"
        ]
    }
}