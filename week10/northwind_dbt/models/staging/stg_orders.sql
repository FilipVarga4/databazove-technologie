SELECT
    NULLIF(TRIM(orderid), '')::INT AS order_id,
    NULLIF(TRIM(customerid), '')::INT AS customer_id,
    NULLIF(TRIM(employeeid), '')::INT AS employee_id,
    NULLIF(TRIM(orderdate), '')::TIMESTAMP AS order_date,
    NULLIF(TRIM(shipperid), '')::INT AS shipper_id
FROM {{ source('bronze', 'orders') }}
