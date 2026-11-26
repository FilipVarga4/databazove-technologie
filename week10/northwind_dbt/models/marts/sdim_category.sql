SELECT
    category_id AS id,
    category_name
FROM {{ ref('stg_categories') }}
