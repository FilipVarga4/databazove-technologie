SELECT
    NULLIF(TRIM(orderdetailid), '')::INT AS order_detail_id,
    NULLIF(TRIM(orderid), '')::INT AS order_id,
    NULLIF(TRIM(productid), '')::INT AS product_id,
    NULLIF(TRIM(quantity), '')::INT AS quantity
FROM {{ source('bronze', 'orderdetails') }}
