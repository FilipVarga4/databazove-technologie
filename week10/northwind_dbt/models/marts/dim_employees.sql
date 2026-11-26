SELECT
    employee_id AS id,
    first_name,
    last_name,
    birth_date
FROM {{ ref('stg_employees') }}
