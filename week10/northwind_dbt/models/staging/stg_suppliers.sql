SELECT
    NULLIF(TRIM(supplierid), '')::INT AS supplier_id,
    NULLIF(TRIM(suppliername), '') AS supplier_name,
    NULLIF(TRIM(contactname), '') AS contact_name,
    NULLIF(TRIM(address), '') AS address,
    NULLIF(TRIM(city), '') AS city,
    NULLIF(TRIM(postalcode), '') AS postal_code,
    NULLIF(TRIM(country), '') AS country,
    NULLIF(TRIM(phone), '') AS phone
FROM {{ source('bronze', 'suppliers') }}
