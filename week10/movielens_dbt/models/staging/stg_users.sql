SELECT
    NULLIF(TRIM(id), '')::INT AS user_id,
    NULLIF(TRIM(age), '')::INT AS age,
    UPPER(NULLIF(TRIM(gender), '')) AS gender,
    NULLIF(TRIM(occupation_id), '')::INT AS occupation_id,
    NULLIF(TRIM(zip_code), '') AS zip_code
FROM {{ source('bronze', 'users') }}
