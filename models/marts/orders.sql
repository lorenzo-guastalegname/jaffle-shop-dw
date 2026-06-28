-- Mart: one row per order with customer details and payment info.
select
    o.order_id,
    o.order_date,
    o.status,
    o.amount                                        as order_amount,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    p.payment_method,
    coalesce(p.amount, 0)                           as payment_amount
from {{ ref('stg_orders') }}         as o
left join {{ ref('stg_customers') }} as c
    on o.customer_id = c.customer_id
left join {{ ref('stg_payments') }}  as p
    on o.order_id = p.order_id
