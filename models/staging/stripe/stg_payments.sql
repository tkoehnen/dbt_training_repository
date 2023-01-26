--{{ config(materialized='view') }}

with source as (
    select * from {{ source('stripe', 'payment') }}
),

staged as (

    select 
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as payment_status,
        -- convert amount stored in 'cents' to 'dollars'
        amount / 100 as amount,
        created as payment_created_date,
        _batched_at
    from source

)

select * from staged
