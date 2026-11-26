SELECT
    NULLIF(TRIM(employeeid), '')::INT AS employee_id,
    NULLIF(TRIM(lastname), '') AS last_name,
    NULLIF(TRIM(firstname), '') AS first_name,
    NULLIF(TRIM(birthdate), '')::DATE AS birth_date,
    NULLIF(TRIM(photo), '') AS photo,
    NULLIF(TRIM(notes), '') AS notes
FROM {{ source('bronze', 'employees') }}
