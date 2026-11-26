SELECT
    DATE_TRUNC('month', d.full_date)::DATE AS sales_month,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    COUNT(DISTINCT f.id) AS order_items_count
FROM {{ ref('fact_orders') }} f
JOIN {{ ref('dim_date') }} d ON d.id = f.date_id
GROUP BY DATE_TRUNC('month', d.full_date)
