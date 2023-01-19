with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('fct_orders') }}
    --where order_status <> 'returned'
),

customer_order_summary as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(distinct(order_id)) as number_of_orders,
        sum(ifnull(amount, 0)) as lifetime_value
    from orders
    group by customer_id
    
),

final as (
    select
        customers.customer_id as customer_id,
        customers.first_name,
        customers.last_name,
        customer_order_summary.first_order_date,
        customer_order_summary.most_recent_order_date,
        coalesce(customer_order_summary.number_of_orders, 0) as number_of_orders,
        ifnull(customer_order_summary.lifetime_value, 0) as lifetime_value
    from customers
      left join customer_order_summary using (customer_id)

)

select * from final
    order by customer_id asc