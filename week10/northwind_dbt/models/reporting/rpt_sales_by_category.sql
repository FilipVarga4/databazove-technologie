SELECT
    c.category_name,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity
FROM {{ ref('fact_orders') }} f
JOIN {{ ref('dim_product') }} p ON p.id = f.product_id
JOIN {{ ref('sdim_category') }} c ON c.id = p.sdim_category_id
GROUP BY c.category_name
