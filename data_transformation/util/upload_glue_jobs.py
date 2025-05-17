import boto3
from pathlib import Path
import os

BUCKET = "skyflow-pipeline-sushant"
LOCAL_FOLDER = Path("data_transformation")
S3_PREFIX = "scripts/"

s3 = boto3.client("s3")

def upload_glue_scripts():
    for file in LOCAL_FOLDER.glob("*.py"):
        s3_key = f"{S3_PREFIX}{file.name}"
        s3.upload_file(str(file), BUCKET, s3_key)
        print(f"✅ Uploaded: {file.name} → s3://{BUCKET}/{s3_key}")

if __name__ == "__main__":
    upload_glue_scripts()
