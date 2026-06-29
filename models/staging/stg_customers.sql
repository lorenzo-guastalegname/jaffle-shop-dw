-- Staging: clean and standardise raw customers.
-- feat(TICK-101): add full_name and customer_tier for CRM segmentation project
select
    customer_id,
    first_name,
    last_name,
    lower(email) as email,
    concat(first_name, ' ', last_name) as full_name,
    case
        when lifetime_orders >= 10 then 'platinum'
        when lifetime_orders >= 5 then 'gold'
        when lifetime_orders >= 1 then 'silver'
        else 'new'
    end as customer_tier
from {{ source('raw', 'customers') }}
where customer_id is not null