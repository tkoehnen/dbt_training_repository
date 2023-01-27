select
    customer_id,
    order_date,
    count(order_id) as order_count
from {{ ref('stg_orders') }}
group by 1,2
