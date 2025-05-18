resource "aws_sns_topic" "snowflake_topic" {
  name = "snowflake-skyflow-topic"
}

resource "aws_sqs_queue" "snowflake_queue" {
  name = "snowflake-skyflow-queue"
}

resource "aws_sns_topic_subscription" "sqs_sub" {
  topic_arn = aws_sns_topic.snowflake_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.snowflake_queue.arn
}

resource "aws_s3_bucket_notification" "s3_notify_snowflake" {
  bucket = var.skyflow_bucket_name

  topic {
    topic_arn = aws_sns_topic.snowflake_topic.arn
    events    = ["s3:ObjectCreated:*"]

    filter_suffix = ".parquet"

    filter_prefix = "processed/passenger_events/"
  }

  depends_on = [aws_sns_topic.snowflake_topic]
}
