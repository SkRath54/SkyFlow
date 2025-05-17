import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql import SparkSession
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col, upper
from pyspark.sql.functions import when

# Glue boilerplate
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Input: raw JSON
raw_df = spark.read.option("multiline", "true").json("s3://skyflow-pipeline-sushant/raw/passenger_events/")

# OR
# dynamic_df = glueContext.create_dynamic_frame_from_options(
#     connection_type="s3",
#     connection_options={"paths": ["s3://skyflow-pipeline-sushant/raw/passenger_events/"]},
#     format="json"
# )
# raw_df = dynamic_df.toDF()

# Transform
cleaned_df = raw_df.dropDuplicates(["event_id"]).withColumn(
    "event_type", upper(col("event_type"))
)

cleaned_df = cleaned_df.withColumn(
    "ticket_class_rank",
    when(col("ticket_class") == "ECONOMY", 1)
    .when(col("ticket_class") == "BUSINESS", 2)
    .when(col("ticket_class") == "FIRST", 3)
    .otherwise(None)
)

# Output: Parquet format
cleaned_df.write.mode("overwrite").parquet(
    "s3://skyflow-pipeline-sushant/processed/passenger_events/"
)

job.commit()
