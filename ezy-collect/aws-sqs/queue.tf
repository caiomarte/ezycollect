resource "aws_sqs_queue" "queue" {
  name                       = var.queue_name
  visibility_timeout_seconds = var.message_visibility_timeout
  message_retention_seconds  = var.message_retention_period
  max_message_size           = var.message_size_max
  delay_seconds              = var.message_delay
  receive_wait_time_seconds  = var.message_long_polling
  deduplication_scope        = var.message_deduplication

  policy = data.aws_iam_policy_document.policy.json

  fifo_queue                  = var.fifo_queue.enabled
  content_based_deduplication = var.fifo_queue.enabled ? var.fifo_queue.content_based_deduplication : null
  fifo_throughput_limit       = var.fifo_queue.enabled ? var.fifo_queue.throughput_limit : null

  sqs_managed_sse_enabled           = var.message_encryption.enabled
  kms_master_key_id                 = var.message_encryption.enabled ? (var.message_encryption.key_id != "" ? var.message_encryption.key_id : aws_kms_key.key[0].key_id) : null
  kms_data_key_reuse_period_seconds = var.message_encryption.enabled ? var.message_encryption.key_cache_period : null
}