variable "skyflow_bucket_name" {
  description = "SkyFlow Bucket name"
  type        = string
  default     = "skyflow-pipeline-sushant"
}

variable "snowflake_role_name" {
  description = "Name of the Snowflake IAM role to attach SQS policy to"
  type        = string
  default     = "SnowFlakeSkyFlowAccessRole"
}