variable "queue_name" {
  description = "(Optional) Name of the queue. Must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long."
  type        = string
  default = ""

  validation {
    condition     = can(regex("^[a-zA-Z]{1}[a-zA-Z0-9_-]{0,79}$", var.queue_name))
    error_message = "Invalid. Must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long."
  }
}

variable "message_visibility_timeout" {
  description = "Amount of time messages in the queue are visible for, specified in seconds. Must range from 0 to 43200 (12 hours). Defaults to 30."
  type        = number
  default     = 30

  validation {
    condition     = var.message_visibility_timeout >= 0 && var.message_visibility_timeout <= 43200
    error_message = "Invalid. Must range from 0 to 43200 seconds."
  }
}

variable "message_retention_period" {
  description = "Amount of time the queue retains messages for, specified in seconds. Must range from 60 (1 minute) to 1209600 (14 days). Defaults to 345600 (4 days)."
  type        = number
  default     = 345600

  validation {
    condition     = var.message_retention_period >= 60 && var.message_retention_period <= 1209600
    error_message = "Invalid. Must range from 60 to 1209600 seconds."
  }
}

variable "message_size_max" {
  description = "Size limit for messages accepted by the queue, specified in bytes. Must range from 1024 (1 KiB) to 262144 (256 KiB). Defaults to 262144 (256 KiB)."
  type        = number
  default     = 262144

  validation {
    condition     = var.message_size_max >= 1024 && var.message_size_max <= 262144
    error_message = "Invalid. Must range from 1024 to 262144 bytes."
  }
}

variable "message_delay" {
  description = "Amount of time to delay messages in the queue for, specified in seconds. Must range from 0 to 900 (15 minutes). Defaults to 0."
  type        = number
  default     = 0

  validation {
    condition     = var.message_delay >= 0 && var.message_delay <= 900
    error_message = "Invalid. Must range from 0 to 900 seconds."
  }
}

variable "message_long_polling" {
  description = "Amount of time to wait before returning ReceiveMessage calls, specified in seconds. Must range from 0 to 20. Defaults to 0."
  type        = number
  default     = 0

  validation {
    condition     = var.message_long_polling >= 0 && var.message_long_polling <= 20
    error_message = "Invalid. Must range from 0 to 20."
  }
}

variable "permissions_send" {
  description = "(Optional) List of IAM Users, IAM Roles, and AWS Accounts that can send messages to the queue."
  type = object({
    users    = list(string)
    roles    = list(string)
    accounts = list(string)
    cidrs    = list(string)
  })

  default = {
    users    = []
    roles    = []
    accounts = []
    cidrs    = []
  }
}

variable "permissions_retrieve" {
  description = "(Optional) List of IAM Users, IAM Roles, and AWS Accounts that can retrieve messages from the queue."
  type = object({
    users    = list(string)
    roles    = list(string)
    accounts = list(string)
    cidrs    = list(string)
  })

  default = {
    users    = []
    roles    = []
    accounts = []
    cidrs    = []
  }
}

variable "permissions_manage" {
  description = "(Optional) List of IAM Users, IAM Roles, and AWS Accounts that can manage the queue. The queue creator receives these permissions by default."
  type = object({
    users    = list(string)
    roles    = list(string)
    accounts = list(string)
    cidrs    = list(string)
  })

  default = {
    users    = []
    roles    = []
    accounts = []
    cidrs    = []
  }
}

variable "fifo_queue" {
  description = "Whether to create a FIFO queue and enable content-based deduplication, and the level throughput quota applies to. content_based_deduplication and throughput_limit are only set if enabled = true. throughput_limit must be either 'perQueue' or 'perMessageGroupId'. Defaults to {enabled=false content_based_deduplication=false}."
  type = object({
    enabled                     = bool
    content_based_deduplication = bool
    throughput_limit            = string
  })

  default = {
    enabled                     = false
    content_based_deduplication = true
    throughput_limit            = "perQueue"
  }

  validation {
    condition = contains([
      "perQueue",
      "perMessageGroupId"
    ], var.fifo_queue.throughput_limit)
    error_message = "Invalid. throughput_limit must be either 'perQueue' or 'perMessageGroupId'."
  }
}

variable "message_encryption" {
  description = "Whether to enable server-side encryption for messages in the queue, the key to be used, and the amount of time the key can be cached by the queue. If no key_id is provided, a new one is automatically created. key_cache_period must range from 60 (1 minute) to 86,400 (24 hours) seconds. Defaults to {enabled=true key_id='' key_cache_period=300}."
  type = object({
    enabled          = bool
    key_id           = string
    key_cache_period = number
  })
  default = {
    enabled          = true
    key_id           = ""
    key_cache_period = 300
  }

  validation {
    condition     = var.message_encryption.key_cache_period >= 60 && var.message_encryption.key_cache_period <= 86400
    error_message = "Invalid. key_cache_period must range from 60 (1 minute) to 86,400 (24 hours) seconds."
  }
}

variable "message_deduplication" {
  description = "Specifies the level in which message deduplication occurs in the queue. Must be either 'messageGroup' or 'queue'. Defaults to 'queue'."
  type        = string
  default     = "queue"

  validation {
    condition = contains([
      "messageGroup",
      "queue"
    ], var.message_deduplication)
    error_message = "Invalid. Must be either 'messageGroup' or 'queue'."
  }
}