-- Staging: clean and standardise raw customers.
-- fix(TICK-042): trim whitespace from names and email -- source system bug
-- causes join mismatches when email has leading/trailing spaces.
select
    customer_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    lower(trim(email)) as email,
    concat(trim(first_name), ' ', trim(last_name)) as full_name
from {{ source('raw', 'customers') }}
where customer_id is not null