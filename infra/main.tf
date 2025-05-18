module "s3_bucket" {
  source = "./s3_bucket"
  bucket_name = "skyflow-pipeline-sushant"
}

module "iam" {
  source     = "./iam"
  role_name  = "AWSGlueServiceRole-SkyFlow"
}

module "glue_job" {
  source         = "./glue_job"
  glue_role_arn  = module.iam.glue_role_arn
}

module "snowflake_integration" {
  source = "./snowflake_integration"

  snowflake_external_id       = "VC54687_SFCRole=2_t1S8+TZRva6fAI9/p8X5CcqIFSk="
  snowflake_iam_user_arn      = "arn:aws:iam::231580209547:user/v3311000-s"
  snowflake_storage_role_name = "SnowFlakeSkyFlowAccessRole"
}

module "aws_notification" {
  source = "./aws_notification"

  skyflow_bucket_name     = "skyflow-pipeline-sushant"
  snowflake_role_name     = "SnowFlakeSkyFlowAccessRole"
  snowflake_external_id   = "VC54687_SFCRole=2_t1S8+TZRva6fAI9/p8X5CcqIFSk="
  snowflake_iam_user_arn  = "arn:aws:iam::231580209547:user/v3311000-s"
}