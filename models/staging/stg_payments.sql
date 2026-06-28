-- Staging: clean and standardise raw payments.
select
    payment_id,
    order_id,
    lower(payment_method) as payment_method,
    amount
from {{ source('raw', 'payments') }}
where payment_id is not null
