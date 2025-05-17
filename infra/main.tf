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
