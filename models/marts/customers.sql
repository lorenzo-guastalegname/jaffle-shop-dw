-- Mart: one row per customer with lifetime order and payment stats.
-- feat(TICK-101): add dw_load_ts audit column.
with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

order_totals as (
    select
        o.customer_id,
        count(o.order_id) as number_of_orders,
        min(o.order_date) as first_order_date,
        max(o.order_date) as most_recent_order_date,
        sum(p.amount) as lifetime_value
    from orders as o
    left join payments as p on o.order_id = p.order_id
    group by o.customer_id
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    t.first_order_date,
    t.most_recent_order_date,
    coalesce(t.number_of_orders, 0) as number_of_orders,
    coalesce(t.lifetime_value, 0) as lifetime_value,
    current_timestamp() as dw_load_ts
from customers as c
left join order_totals as t on c.customer_id = t.customer_id