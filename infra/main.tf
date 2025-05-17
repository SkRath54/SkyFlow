provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "skyflow_bucket" {
  bucket = var.bucket_name

  tags = {
    Project     = "SkyFlow"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.skyflow_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
