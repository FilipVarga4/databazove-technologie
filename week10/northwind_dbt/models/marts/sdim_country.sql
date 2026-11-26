SELECT DISTINCT
    DENSE_RANK() OVER (ORDER BY country)::INT AS id,
    country AS country_name
FROM {{ ref('stg_customers') }}
WHERE country IS NOT NULL
