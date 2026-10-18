with source as (
    select * from {{ source('raw_northwind', 'products') }}
),

renamed as (
    select
        id as product_id,
        product_code,
        product_name,
        description,
        standard_cost,
        list_price,
        reorder_level,
        target_level,
        quantity_per_unit,
        discontinued,
        minimum_reorder_quantity,
        category
    from source
    where id is not null
)

select * from renamed