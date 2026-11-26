SELECT
    shipper_id AS id,
    shipper_name
FROM {{ ref('stg_shippers') }}
