with employees as (
    select * from {{ ref('stg_employees') }}
)

select
    employee_id,
    concat(first_name, ' ', last_name) as employee_full_name,
    job_title
from employees