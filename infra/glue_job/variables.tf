variable "glue_role_arn" {
  type        = string
  description = "The ARN of the IAM role for the Glue Job"
  default = "arn:aws:iam::861285538783:role/AWSGlueServiceRole-SkyFlow"
}
