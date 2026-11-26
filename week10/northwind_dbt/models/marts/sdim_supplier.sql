SELECT
    supplier_id AS id,
    supplier_name,
    contact_name,
    city,
    country
FROM {{ ref('stg_suppliers') }}
