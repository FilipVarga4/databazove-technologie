SELECT
    NULLIF(TRIM(shipperid), '')::INT AS shipper_id,
    NULLIF(TRIM(shippername), '') AS shipper_name,
    NULLIF(TRIM(phone), '') AS phone
FROM {{ source('bronze', 'shippers') }}
