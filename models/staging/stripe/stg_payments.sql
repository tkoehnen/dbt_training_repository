select 
    id as row_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    amount,
    created as date_created,
    _batched_at as date_batched_at
    
from raw.stripe.payment