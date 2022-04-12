variable "queue_name" {
  description = "Name of the queue. Must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long."
  type        = string

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

variable "message_retention_periond" {
  description = "Amount of time the queue retains messages for, specified in seconds. Must range from 60 (1 minute) to 1209600 (14 days). Defaults to 345600 (4 days)."
  type        = number
  default     = 345600

  validation {
    condition     = var.message_retention_periond >= 60 && var.message_retention_periond <= 1209600
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

variable "permissions" {
  description = "List of permission type and entities to grant it to. Type must be either 'send', 'receive', or 'manage'. Defaults to [{type='' users=[] roles=[] accounts=[] cidrs=[]}]."
  type = list(object({
    type     = string
    users    = list(string)
    roles    = list(string)
    accounts = list(string)
    cidrs    = list(string)
  }))

  default = [
    {
      type     = ""
      users    = []
      roles    = []
      accounts = []
      cidrs    = []
    }
  ]

  validation {
    condition = can([for permission in var.permissions : contains([
      "send",
      "receive",
      "manage"
    ], permission["type"])])
    error_message = "Invalid. Type must be either 'send', 'receive', or 'manage'."
  }
}
