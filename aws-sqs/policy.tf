data "aws_caller_identity" "creator" {}
data "aws_region" "current" {}

locals {
  senders = concat(var.permissions_send.users, var.permissions_send.roles, var.permissions_send.accounts)
  principals_sender = local.senders != [] ? [{
    type        = "AWS"
    identifiers = local.senders
  }] : null

  retrievers = concat(var.permissions_retrieve.users, var.permissions_retrieve.roles, var.permissions_retrieve.accounts)
  principals_retrievers = local.retrievers != [] ? [{
    type        = "AWS"
    identifiers = local.retrievers
  }] : null

  managers = concat(var.permissions_manage.users, var.permissions_manage.roles, var.permissions_manage.accounts, [data.aws_caller_identity.creator.arn])
  principals_managers = [{
    type        = "AWS"
    identifiers = local.managers
  }]
}

data "aws_iam_policy_document" "policy_send" {
  count = local.senders != [] ? 1 : 0

  version   = "2012-10-17"
  policy_id = "${var.queue_name}-send-policy"
  statement {
    sid    = "${var.queue_name}-send-policy"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ListQueues"
    ]
    resources = [
      "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.creator.account_id}:${var.queue_name}"
    ]

    dynamic "principals" {
      for_each = local.principals_sender
      content {
        type        = principals.value["type"]
        identifiers = principals.value["identifiers"]
      }
    }
  }
}

data "aws_iam_policy_document" "policy_retrieve" {
  count = local.retrievers != [] ? 1 : 0
  
  version   = "2012-10-17"
  policy_id = "${var.queue_name}-send-policy"
  statement {
    sid    = "${var.queue_name}-send-policy"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ListQueues"
    ]
    resources = [
      "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.creator.account_id}:${var.queue_name}"
    ]

    dynamic "principals" {
      for_each = local.principals_retrievers
      content {
        type        = principals.value["type"]
        identifiers = principals.value["identifiers"]
      }
    }
  }
}

data "aws_iam_policy_document" "policy_manage" {
  version   = "2012-10-17"
  policy_id = "${var.queue_name}-send-policy"
  statement {
    sid    = "${var.queue_name}-send-policy"
    effect = "Allow"
    actions = [
      "sqs:*"
    ]
    resources = [
      "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.creator.account_id}:${var.queue_name}"
    ]

    dynamic "principals" {
      for_each = local.principals_managers
      content {
        type        = principals.value["type"]
        identifiers = principals.value["identifiers"]
      }
    }
  }
}

data "aws_iam_policy_document" "policy" {
  source_policy_documents = local.senders == [] ? (local.retrievers == [] ? ([
    data.aws_iam_policy_document.policy_manage.json
  ]) : [
    data.aws_iam_policy_document.policy_manage.json,
    data.aws_iam_policy_document.policy_retrieve[0].json
  ]) : [
    data.aws_iam_policy_document.policy_manage.json,
    data.aws_iam_policy_document.policy_retrieve[0].json,
    data.aws_iam_policy_document.policy_send[0].json
  ]
}