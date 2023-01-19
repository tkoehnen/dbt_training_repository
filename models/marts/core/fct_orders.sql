with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
    --where payment_status = 'success'
),

order_payments as (
    select
        order_id,
        sum(case when payment_status = 'success' then amount end) as amount
    from payments
    group by 1
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.order_status,
        coalesce(order_payments.amount, 0) as amount,
        --custom columns
        case when orders.order_status in ('returned', 'pending_return') then coalesce(-order_payments.amount, 0)
            else 0 
            end as amount_returned,
        case when orders.order_status in ('returned', 'pending_return') then 0
            else coalesce(order_payments.amount, 0)
            end as amount_less_returns

    from  orders
      left join order_payments using (order_id)
    --group by 1, 2, 3

)

select * from final
    order by order_id asc
        --, customer_id asc