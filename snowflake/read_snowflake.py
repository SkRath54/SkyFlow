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

cur = conn.cursor()

cur.execute("""
    SELECT 'stage_passenger' AS source, COUNT(*) AS row_count FROM @stage_passenger
    UNION ALL
    SELECT 'passenger_events_external', COUNT(*) FROM passenger_events_external
    UNION ALL
    SELECT 'passenger_events', COUNT(*) FROM passenger_events;
""")

print("\n📊 Row Count Summary:")
rows = cur.fetchall()
for row in rows:
    print(f"{row[0]} → {row[1]}")

cur.close()
conn.close()
