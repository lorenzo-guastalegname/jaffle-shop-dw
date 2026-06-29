-- Intermediate: aggregate payments per customer with method breakdown.
-- feat(TICK-101): feeds the payment_summary mart for CRM project.
select
    o.customer_id,
    count(p.payment_id) as total_payments,
    sum(p.amount) as total_paid,
    sum(case when p.payment_method = 'credit_card' then p.amount else 0 end) as credit_card_amount,
    sum(case when p.payment_method = 'bank_transfer' then p.amount else 0 end) as bank_transfer_amount,
    sum(case when p.payment_method = 'coupon' then p.amount else 0 end) as coupon_amount,
    count(distinct p.payment_method) as payment_methods_used
from {{ ref('stg_orders') }} as o
left join {{ ref('stg_payments') }} as p
    on o.order_id = p.order_id
group by o.customer_id