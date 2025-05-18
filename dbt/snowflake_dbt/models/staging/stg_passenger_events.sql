{{ config(materialized='view') }}

SELECT
  event_id,
  passenger_id,
  event_type,
  ticket_class,
  event_timestamp,
  flight_number,
  seat_number,
  departure_airport,
  arrival_airport,
  ticket_class_rank
FROM {{ source('raw', 'passenger_events_external') }}
