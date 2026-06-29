-- Staging: clean and standardise raw orders.
select
    order_id,
    customer_id,
    cast(order_date as date) as order_date,
    amount,
    lower(status) as status
from {{ source('raw', 'orders') }}
where order_id is not null
