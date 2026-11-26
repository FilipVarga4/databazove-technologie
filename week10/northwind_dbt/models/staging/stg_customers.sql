SELECT
    NULLIF(TRIM(customerid), '')::INT AS customer_id,
    NULLIF(TRIM(customername), '') AS customer_name,
    NULLIF(TRIM(contactname), '') AS contact_name,
    NULLIF(TRIM(address), '') AS address,
    NULLIF(TRIM(city), '') AS city,
    NULLIF(TRIM(postalcode), '') AS postal_code,
    NULLIF(TRIM(country), '') AS country
FROM {{ source('bronze', 'customers') }}
