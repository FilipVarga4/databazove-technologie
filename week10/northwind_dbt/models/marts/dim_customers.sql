SELECT
    c.customer_id AS id,
    c.customer_name,
    c.contact_name,
    c.address,
    ci.id AS sdim_city_id,
    co.id AS sdim_country_id
FROM {{ ref('stg_customers') }} c
LEFT JOIN {{ ref('sdim_city') }} ci ON ci.city_name = c.city
LEFT JOIN {{ ref('sdim_country') }} co ON co.country_name = c.country
