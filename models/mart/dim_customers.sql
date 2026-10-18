with customers as (
    select * from {{ ref('stg_customers') }}
)

select
    customer_id,
    company_name,
    city,
    country_region as country
from customers