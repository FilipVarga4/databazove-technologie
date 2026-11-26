SELECT DISTINCT
    DENSE_RANK() OVER (ORDER BY city)::INT AS id,
    city AS city_name
FROM {{ ref('stg_customers') }}
WHERE city IS NOT NULL
