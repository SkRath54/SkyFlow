variable "snowflake_external_id" {
  description = "External ID from Snowflake storage integration"
  type        = string
  default     = "VC54687_SFCRole=2_o+feUU85yx5cQRvNtKN7Z2CzlCU="
}

variable "snowflake_iam_user_arn" {
  description = "Snowflake IAM user ARN (STORAGE_AWS_IAM_USER_ARN)"
  type        = string
  default     = "arn:aws:iam::231580209547:user/v3311000-s"
}

variable "skyflow_bucket_name" {
  description = "SkyFlow S3 bucket name"
  type        = string
  default     = "skyflow-pipeline-sushant"
}

variable "snowflake_storage_role_name" {
  description = "Snowflake Storage Access Role Name"
  type        = string
  default     = "SnowFlakeSkyFlowAccessRole"
}


resource "aws_iam_role" "snowflake_storage_access" {
  name = var.snowflake_storage_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.snowflake_iam_user_arn
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.snowflake_external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "snowflake_s3_access" {
  name = "SnowFlakeSkyFlowS3ReadAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowSnowflakeReadAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.skyflow_bucket_name}",
          "arn:aws:s3:::${var.skyflow_bucket_name}/processed/passenger_events/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "snowflake_s3_policy_attachment" {
  role       = aws_iam_role.snowflake_storage_access.name
  policy_arn = aws_iam_policy.snowflake_s3_access.arn
}
