{% macro refresh_external_table() %}
    ALTER EXTERNAL TABLE SKYFLOWDB.PUBLIC.passenger_events_external REFRESH;
{% endmacro %}