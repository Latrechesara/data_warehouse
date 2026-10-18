with source as (
    select * from {{ source('raw_northwind', 'orders') }}
),

renamed as (
    select
        id as order_id,
        employee_id,
        customer_id,
        order_date,
        shipped_date,
        shipper_id,
        ship_name,
        ship_address,
        ship_city,
        ship_state_province,
        ship_zip_postal_code,
        ship_country_region,
        shipping_fee,
        taxes,
        payment_type,
        paid_date,
        status_id as order_status_id
    from source
    where id is not null
)

select * from renamed