import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql import SparkSession
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col, upper

# Glue boilerplate
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Input: raw JSON
raw_df = spark.read.json("s3://skyflow-pipeline-sushant/raw/passenger_events/")

# Clean & transform
cleaned_df = raw_df.dropDuplicates(["event_id"]).withColumn(
    "event_type", upper(col("event_type"))
)

# Optional enrichment: map ticket_class to numeric rank
class_map = {
    "ECONOMY": 1,
    "BUSINESS": 2,
    "FIRST": 3
}
for key, value in class_map.items():
    cleaned_df = cleaned_df.replace(key, value, subset=["ticket_class"])

# Output: Parquet format
cleaned_df.write.mode("overwrite").parquet(
    "s3://skyflow-pipeline-sushant/processed/passenger_events/"
)

job.commit()
