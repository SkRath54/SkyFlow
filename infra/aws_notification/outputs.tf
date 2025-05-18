output "sns_topic_arn" {
  value = aws_sns_topic.snowflake_topic.arn
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.snowflake_queue.arn
}
