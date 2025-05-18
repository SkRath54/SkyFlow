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
  description = "SkyFlow Bucket name"
  type        = string
  default     = "skyflow-pipeline-sushant"
}

variable "snowflake_role_name" {
  description = "Name of the Snowflake IAM role to attach SQS policy to"
  type        = string
}