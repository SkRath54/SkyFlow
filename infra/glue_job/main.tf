resource "aws_glue_job" "skyflow_transform_passenger_events" {
  name     = "skyflow-transform-passenger-events"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://skyflow-pipeline-sushant/scripts/passenger_events_transform.py"
    python_version  = "3"
  }

  glue_version      = "3.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  default_arguments = {
    "--job-language" = "python"
    "--TempDir"      = "s3://skyflow-pipeline-sushant/temp/"
    "--JOB_NAME"     = "skyflow-transform-passenger-events"
  }

  max_retries = 0
  timeout     = 10
}
