with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
    where status = 'success'
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount end) as amount
    from payments
    group by 1
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        --orders.status,
        --sum(ifnull(payments.amount, 0)) as amount
        coalesce(order_payments.amount, 0) as amount

    from  orders
      left join order_payments using (order_id)
    --group by 1, 2, 3

)

select * from final
    order by order_id asc
        --, customer_id asc