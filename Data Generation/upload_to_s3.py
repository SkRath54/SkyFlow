import boto3
from pathlib import Path
import os

# Use absolute path relative to script location
base_dir = Path(__file__).resolve().parent
local_folder = base_dir / "passenger_events"

bucket_name = 'skyflow-pipeline-sushant'
s3_prefix = 'raw/passenger_events/'

s3 = boto3.client('s3')

for file_name in os.listdir(local_folder):
    if file_name.endswith('.json'):
        full_path = os.path.join(local_folder, file_name)
        s3.upload_file(full_path, bucket_name, s3_prefix + file_name)
        print(f"Uploaded: {file_name}")