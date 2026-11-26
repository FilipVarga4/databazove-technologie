SELECT
    NULLIF(TRIM(productid), '')::INT AS product_id,
    NULLIF(TRIM(productname), '') AS product_name,
    NULLIF(TRIM(supplierid), '')::INT AS supplier_id,
    NULLIF(TRIM(categoryid), '')::INT AS category_id,
    NULLIF(TRIM(unit), '') AS product_unit,
    NULLIF(TRIM(price), '')::DECIMAL(10, 2) AS price
FROM {{ source('bronze', 'products') }}
