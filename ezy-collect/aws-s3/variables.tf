variable "bucket_name" {
    description = "(Optional) The name of the bucket. Must be universally unique; contain only lowercase letters, numbers, dots, and hyphens; begin and end with a letter or number; and range from 3 to 63 characters in length. Check other naming rules- https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html."
    type = string
    default = ""
    
  validation {
    condition     = can(regex("^[a-z0-9]{1}[a-z0-9.-]{1,61}[a-z0-9]{1}$", var.bucket_name))
    error_message = "Invalid. Must be universally unique; contain only lowercase letters, numbers, dots, and hyphens; begin and end with a letter or number; and range from 3 to 63 characters in length."
  }
}

variable "object_lock" {
    description = "Whether to enable write-once-read-many (WORM) in the bucket, the retention mode, and the amount of time for the retention period. mode and days or years are only set if enabled = true. Mode must be either 'COMPLIANCE' or 'GOVERNANCE'. At least one of the retention period attributes must be greater than 0. If both days and years are specified, years takes precedence. Defaults to {enabled=false mode='GOVERNANCE' days=0 years=3}."
    type = object({
      enabled = bool
      mode = string
      days = number
      years = number
    })

    default = {
      enabled = false
      mode = "GOVERNANCE"
      days = 0
      years = 3
    }

    validation {
      condition = contains([
        "COMPLIANCE",
        "GOVERNANCE"
      ], var.object_lock.mode) && var.object_lock.days >= 0 && var.object_lock.years >= 0 && var.object_lock.days + var.object_lock.years > 0
      error_message = "Invalid. Mode must be either 'COMPLIANCE' or 'GOVERNANCE and at least one of the retention period attributes- days or years- must be greater than 0."
    }
}

variable "logging_bucket" {
    description = "(Optional) The ID of a bucket to store server access logs. If no value is provided, server access logs are sent to the same bucket."
    type = string
    default = ""
}

variable "sysadmin_group" {
    description = "(Optional) The URI of the an IAM Group that can read server access log files."
    type = string
    default = ""
}

variable "cloudfront_distribution" {
  description = "Whether to allow a CloudFront distribution to serve objects from the bucket, and the corresponding OAI's ID. Defaults to {enabled=false oai=''}."
  type = object({
    enabled = bool
    oai = string
  })

  default = {
    enabled = false
    oai = ""
  }

  validation {
    condition = var.cloudfront_distribution.enabled ? var.cloudfront_distribution.oai != "" : true
    error_message = "Invalid. If enabled = true, an oai value must be provided."
  }
}