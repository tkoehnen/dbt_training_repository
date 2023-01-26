--{{ config(materialized='view') }}

with source as (
    select * from {{ source('jaffle_shop', 'orders') }}
),
staged as (
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status as order_status
    from source
)
select * from staged

{{ limit_data_in_dev(column_name = 'order_date', dev_days_of_data=2000) }}
