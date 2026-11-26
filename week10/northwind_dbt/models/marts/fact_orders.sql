{{ config(
    indexes=[
        {'columns': ['date_id']},
        {'columns': ['time_id']},
        {'columns': ['customer_id']},
        {'columns': ['product_id']},
        {'columns': ['employee_id']},
        {'columns': ['shipper_id']}
    ]
) }}

SELECT
    od.order_detail_id AS id,
    od.quantity,
    (od.quantity * p.price)::DECIMAL(10, 2) AS sales_amount,
    p.price::DECIMAL(10, 2) AS prod_price,
    TO_CHAR(o.order_date, 'YYYYMMDD')::INT AS date_id,
    TO_CHAR(o.order_date, 'HH24MISS')::INT AS time_id,
    dc.id AS customer_id,
    dp.id AS product_id,
    de.id AS employee_id,
    ds.id AS shipper_id
FROM {{ ref('stg_orderdetails') }} od
JOIN {{ ref('stg_orders') }} o ON o.order_id = od.order_id
JOIN {{ ref('stg_products') }} p ON p.product_id = od.product_id
JOIN {{ ref('dim_customers') }} dc ON dc.id = o.customer_id
JOIN {{ ref('dim_product') }} dp ON dp.id = od.product_id
JOIN {{ ref('dim_employees') }} de ON de.id = o.employee_id
JOIN {{ ref('dim_shipper') }} ds ON ds.id = o.shipper_id
