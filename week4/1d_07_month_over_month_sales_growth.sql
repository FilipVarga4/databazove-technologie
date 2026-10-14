WITH monthly_sales_cte AS (
    SELECT DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
sales_with_prev AS (
    SELECT month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY month
        ) AS prev_month_sales
    FROM monthly_sales_cte
)
SELECT month,
    monthly_sales,
    prev_month_sales,
    monthly_sales - prev_month_sales AS sales_change,
    ROUND(
        (
            (monthly_sales - prev_month_sales) / prev_month_sales
        ) * 100.0,
        2
    ) AS growth_percentage
FROM sales_with_prev
ORDER BY month ASC;
