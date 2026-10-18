with orders as (
    select * from {{ ref('stg_orders') }}
),

order_details as (
    select * from {{ ref('stg_order_details') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

joined as (
    select
        od.order_detail_id,
        od.order_id,
        o.customer_id,
        o.employee_id,
        od.product_id,
        p.product_name,
        od.quantity,
        od.unit_price,
        od.discount,
        
        -- Calcul du montant total de la ligne avec la remise
        (od.quantity * od.unit_price * (1 - coalesce(od.discount, 0))) as line_total

    from order_details od
    inner join orders o on od.order_id = o.order_id
    left join products p on od.product_id = p.product_id
)

select * from joined