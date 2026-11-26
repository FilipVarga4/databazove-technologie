SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity
FROM {{ ref('fact_orders') }} f
JOIN {{ ref('dim_employees') }} e ON e.id = f.employee_id
GROUP BY e.id, e.first_name, e.last_name
