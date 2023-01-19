with payments as (
    select * from {{ ref('stg_payments') }}
)

-- Specific case: Refunds have a negative amount, so the total amount should always be >= 0.
    -- Therefore return records where this isn't true to make the test fail.
select
    order_id,
    sum(amount) as total_amount
from payments
group by 1
having not(total_amount >= 0)