with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

employees as (
    select * from {{ ref('stg_employees') }}
),

joined as (
    select
        o.order_id,
        o.customer_id,
        c.company_name as customer_company_name,
        c.city as customer_city,
        c.country_region as customer_country,
        
        o.employee_id,
        concat(e.first_name, ' ', e.last_name) as employee_full_name,
        e.job_title as employee_job_title,
        
        o.order_date,
        o.shipped_date,
        o.shipper_id,
        o.shipping_fee as freight,
        o.ship_name,
        o.ship_address,
        o.ship_city,
        o.ship_country_region as ship_country,
        o.order_status_id

    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join employees e on o.employee_id = e.employee_id
)

select * from joined