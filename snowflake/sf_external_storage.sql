---> set Role Context
USE ROLE ACCOUNTADMIN;
---> set Warehouse Context
USE WAREHOUSE LOCALTOCLOUDWH;
---> create and set the Database
-- CREATE OR REPLACE DATABASE SKYFLOWDB;
USE DATABASE SKYFLOWDB;

CREATE OR REPLACE STORAGE INTEGRATION skyflow_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::861285538783:role/SnowFlakeSkyFlowAccessRole'
  STORAGE_ALLOWED_LOCATIONS = ('s3://skyflow-pipeline-sushant/processed/passenger_events/')
  COMMENT = 'Allows Snowflake to access SkyFlow processed S3 data';

DESC INTEGRATION skyflow_integration;

/*
property	                property_type	property_value	property_default
ENABLED	Boolean	            true	        false
STORAGE_PROVIDER	        String	        S3
STORAGE_ALLOWED_LOCATIONS	List	        s3://skyflow-pipeline-sushant/processed/passenger_events/	[]
STORAGE_BLOCKED_LOCATIONS	List		    []
STORAGE_AWS_IAM_USER_ARN	String	        arn:aws:iam::231580209547:user/v3311000-s
STORAGE_AWS_ROLE_ARN	    String	        arn:aws:iam::861285538783:role/SnowFlakeSkyFlowAccessRole
STORAGE_AWS_EXTERNAL_ID	    String	        VC54687_SFCRole=2_o+feUU85yx5cQRvNtKN7Z2CzlCU=
USE_PRIVATELINK_ENDPOINT	Boolean	        false	        false
COMMENT	                    String	        Allows          Snowflake to access SkyFlow processed S3 data
*/

CREATE OR REPLACE STAGE stage_passenger
  URL = 's3://skyflow-pipeline-sushant/processed/passenger_events/'
  STORAGE_INTEGRATION = skyflow_integration
  FILE_FORMAT = (TYPE = 'PARQUET');

SHOW STAGES;

LIST @stage_passenger;

-- All data from the Stage loads as a single column $1 in the Snowflake table
CREATE OR REPLACE TABLE passenger_events AS
SELECT * FROM @stage_passenger;

-- Define the Schema of the table based on the JSON extraction

SELECT
  $1:event_id::STRING AS event_id,
  $1:passenger_id::STRING AS passenger_id,
  $1:event_type::STRING AS event_type,
  $1:ticket_class::STRING AS ticket_class,
  $1:event_timestamp::TIMESTAMP AS event_time,
  $1:flight_number::STRING AS flight_number,
  $1:seat_number::STRING AS seat_number,
  $1:departure_airport::STRING AS departure_airport,
  $1:arrival_airport::STRING AS arrival_airport,
  $1:ticket_class_rank::INTEGER AS ticket_class_rank
FROM @stage_passenger;


CREATE OR REPLACE EXTERNAL TABLE passenger_events_external (
  event_id STRING AS (value:event_id::STRING),
  passenger_id STRING AS (value:passenger_id::STRING),
  event_type STRING AS (value:event_type::STRING),
  ticket_class STRING AS (value:ticket_class::STRING),
  event_timestamp TIMESTAMP AS (value:event_timestamp::TIMESTAMP),
  flight_number STRING AS (value:flight_number::STRING),
  seat_number STRING AS (value:seat_number::STRING),
  departure_airport STRING AS (value:departure_airport::STRING),
  arrival_airport STRING AS (value:arrival_airport::STRING),
  ticket_class_rank INTEGER AS (value:ticket_class_rank::INTEGER)
)
WITH LOCATION = @stage_passenger
FILE_FORMAT = (TYPE = 'PARQUET')
AUTO_REFRESH = TRUE;

SELECT * FROM passenger_events_external;


-- Materialize into a native table (fast querying + dbt-ready)
CREATE OR REPLACE TABLE passenger_events AS
SELECT * FROM passenger_events_external;


-- OR Create the native table directly from Stage

CREATE OR REPLACE TABLE passenger_events AS
SELECT
  $1:event_id::STRING AS event_id,
  $1:passenger_id::STRING AS passenger_id,
  $1:event_type::STRING AS event_type,
  $1:ticket_class::STRING AS ticket_class,
  $1:event_timestamp::TIMESTAMP AS event_time,
  $1:flight_number::STRING AS flight_number,
  $1:seat_number::STRING AS seat_number,
  $1:departure_airport::STRING AS departure_airport,
  $1:arrival_airport::STRING AS arrival_airport,
  $1:ticket_class_rank::INTEGER AS ticket_class_rank
FROM @stage_passenger;

ALTER EXTERNAL TABLE SKYFLOWDB.PUBLIC.passenger_events_external
SET AUTO_REFRESH = TRUE;


ALTER EXTERNAL TABLE passenger_events_external REFRESH;

SELECT count(*) stage_count FROM @stage_passenger;
SELECT count(*) external_count FROM passenger_events_external;
SELECT COUNT(*) static_count FROM passenger_events;