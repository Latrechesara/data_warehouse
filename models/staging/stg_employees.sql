with source as (
    select * from {{ source('raw_northwind', 'employees') }}
),

renamed as (
    select
        -- Identifiants
        cast(id as integer) as employee_id,

        -- Informations personnelles et professionnelles
        -- (Vérifiez si 'company' existe bien dans votre table raw d'employés)
        company as company_name, 
        last_name,
        first_name,
        email_address,
        job_title,

        -- Contacts
        business_phone,
        home_phone,
        mobile_phone,
        fax_number,

        -- Adresse
        address,
        city,
        state_province,
        zip_postal_code,
        country_region,

        -- Divers
        web_page,
        notes

    from source
    where id is not null
)

select * from renamed