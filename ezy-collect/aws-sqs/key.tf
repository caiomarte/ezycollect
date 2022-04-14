resource "aws_kms_key" "key" {
  count = var.message_encryption.enabled ? (var.message_encryption.key_id == "" ? 1 : 0) : 0

  description         = "KMS Key to encrypt messages in the ${var.queue_name} queue."
  enable_key_rotation = true
}