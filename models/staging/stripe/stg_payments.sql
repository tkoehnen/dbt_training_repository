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
        amount as amount_cents,
        -- convert amount stored in 'cents' to 'dollars'
        round(amount / 100, 4) as amount_usd,
        {{ cents_to_dollars('amount', 4) }} as amount,
        created as payment_created_date,
        _batched_at
    from source
)
select * from staged
