output "endpoint" {
    description = "The endpoint of the SQS Queue."
    value = aws_sqs_queue.queue.id
}