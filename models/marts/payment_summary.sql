-- Mart: customer-level payment summary for CRM segmentation.
-- feat(TICK-101): used by CRM team to score payment behaviour.
select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.full_name,
    c.customer_tier,
    coalesce(p.total_payments, 0) as total_payments,
    coalesce(p.total_paid, 0) as total_paid,
    coalesce(p.credit_card_amount, 0) as credit_card_amount,
    coalesce(p.bank_transfer_amount, 0) as bank_transfer_amount,
    coalesce(p.coupon_amount, 0) as coupon_amount,
    coalesce(p.payment_methods_used, 0) as payment_methods_used
from {{ ref('stg_customers') }} as c
left join {{ ref('int_payments_by_customer') }} as p
    on c.customer_id = p.customer_id