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
