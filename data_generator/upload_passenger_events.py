import boto3
from pathlib import Path

# Use absolute path relative to script location
base_dir = Path(__file__).resolve().parent
local_folder = base_dir / "passenger_events"

bucket_name = 'skyflow-pipeline-sushant'
s3_prefix = 'raw/passenger_events/'

s3 = boto3.client('s3')

for file_path in local_folder.glob("*.json"):
    s3_key = f"{s3_prefix}{file_path.name}"
    s3.upload_file(str(file_path), bucket_name, s3_key)
    print(f"✅ Uploaded: {file_path.name}")
