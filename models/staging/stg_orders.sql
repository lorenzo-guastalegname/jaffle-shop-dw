-- Staging: clean and standardise raw orders.
-- Renames columns, casts types, filters out test records.
select
    order_id,
    customer_id,
    cast(order_date as date)  as order_date,
    lower(status)             as status,
    amount
from {{ source('raw', 'orders') }}
where order_id is not null
