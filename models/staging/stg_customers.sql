-- Staging: clean and standardise raw customers.
select
    customer_id,
    first_name,
    last_name,
    lower(email) as email
from {{ source('raw', 'customers') }}
where customer_id is not null