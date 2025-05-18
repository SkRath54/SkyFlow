from dotenv import load_dotenv
import os
import snowflake.connector

load_dotenv()

conn = snowflake.connector.connect(
    user=os.getenv("SF_USER"),
    password=os.getenv("SF_PASSWORD"),
    account=os.getenv("SF_ACCOUNT"),
    warehouse=os.getenv("SF_WAREHOUSE"),
    database=os.getenv("SF_DATABASE"),
    schema=os.getenv("SF_SCHEMA"),
    role=os.getenv("SF_ROLE")
)

# Now run your query...
