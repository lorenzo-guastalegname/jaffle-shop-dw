-- Staging: clean and standardise raw customers.
-- fix(TICK-042): trim whitespace from names and email
-- feat(TICK-101): add full_name and customer_tier for CRM segmentation
select
    customer_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    lower(trim(email)) as email,
    concat(trim(first_name), ' ', trim(last_name)) as full_name,
    case
        when lifetime_orders >= 10 then 'platinum'
        when lifetime_orders >= 5 then 'gold'
        when lifetime_orders >= 1 then 'silver'
        else 'new'
    end as customer_tier
from {{ source('raw', 'customers') }}
where customer_id is not null
