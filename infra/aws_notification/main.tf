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

  depends_on = [aws_sqs_queue.snowflake_queue]
}

resource "aws_sns_topic_policy" "allow_s3_publish" {
  arn    = aws_sns_topic.snowflake_topic.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowS3Publish",
        Effect    = "Allow",
        Principal = { Service = "s3.amazonaws.com" },
        Action    = "SNS:Publish",
        Resource  = aws_sns_topic.snowflake_topic.arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:s3:::${var.skyflow_bucket_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "snowflake_sqs_policy" {
  name = "SnowflakeSQSAccess"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl"
        ],
        Resource = aws_sqs_queue.snowflake_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_sqs_policy" {
  role       = var.snowflake_role_name
  policy_arn = aws_iam_policy.snowflake_sqs_policy.arn
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

resource "aws_sqs_queue_policy" "allow_sns_publish" {
  queue_url = aws_sqs_queue.snowflake_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id = "${aws_sqs_queue.snowflake_queue.arn}/SQSDefaultPolicy",
    Statement = [
      {
        Sid = "AllowSNSPublish",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = "SQS:SendMessage",
        Resource = aws_sqs_queue.snowflake_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.snowflake_topic.arn
          }
        }
      }
    ]
  })
}
