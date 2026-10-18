with source as (
    select * from {{ source('raw_northwind', 'order_details') }}
),

renamed as (
    select
        id as order_detail_id,
        order_id,
        product_id,
        quantity,
        unit_price,
        discount,
        status_id as order_detail_status_id,
        date_allocated,
        purchase_order_id,
        inventory_id
    from source
    where id is not null
)

select * from renamed