SELECT
    NULLIF(TRIM(categoryid), '')::INT AS category_id,
    NULLIF(TRIM(categoryname), '') AS category_name,
    NULLIF(TRIM(description), '') AS description
FROM {{ source('bronze', 'categories') }}
