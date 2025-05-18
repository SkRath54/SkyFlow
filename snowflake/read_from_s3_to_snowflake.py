import snowflake.connector as snowconn

# Establish connection
conn = snowconn.connect(
    user='SKRATH54',
    password='Krishna@108108108',
    account='XMGIEKT-UT68699',
    warehouse='LOCALTOCLOUDWH',
    database='SKYFLOWDB',
    schema='PUBLIC',
    role='ACCOUNTADMIN'
)

# Create a cursor
cur = conn.cursor()

# Execute query
cur.execute("SELECT COUNT(*) FROM passenger_events_external")

# Fetch result
row = cur.fetchone()
print(f"Total records: {row[0]}")

# Clean up
cur.close()
conn.close()
