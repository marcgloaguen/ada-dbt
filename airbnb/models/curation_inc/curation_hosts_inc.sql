{{
    config(
        database=var('inc_database'),
        schema=var('inc_schema'),
        materialized='incremental',
        unique_key='host_id'
    )
 }}

WITH raw_hosts AS (
    SELECT *
    FROM {{ source("raw_airbnb_data","hosts") }}
)
SELECT *
FROM raw_hosts
{% if is_incremental() %}
where load_timestamp > (select max(load_timestamp) from {{this}} )
{% else %}
join (select host_id, max(load_timestamp) as load_timestamp from {{ source("raw_airbnb_data", "hosts") }} group by 1) t2
on raw_hosts.host_id = t2.host_id and raw_hosts.load_timestamp = t2.load_timestamp
{% endif %}
