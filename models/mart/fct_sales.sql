with order_items as (
    select * from {{ ref('int_order_items') }}
),

orders as (
    select * from {{ ref('int_orders__enriched') }}
)

select
    oi.order_detail_id,
    oi.order_id,
    oi.customer_id,
    oi.employee_id,
    oi.product_id,
    
    o.order_date,
    o.shipped_date,
    
    oi.quantity,
    oi.unit_price,
    oi.discount,
    oi.line_total,
    o.freight

from order_items oi
left join orders o on oi.order_id = o.order_id