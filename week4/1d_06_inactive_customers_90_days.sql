WITH customer_orders AS (
    SELECT DISTINCT c.customer_id,
        c.customer_name,
        MAX(o.order_date) OVER (PARTITION BY c.customer_id) AS last_order_date,
        MAX(o.order_date) OVER () AS latest_order_date
    FROM orders o
        JOIN customers c ON o.customer_id = c.customer_id
)
SELECT customer_id,
    customer_name,
    last_order_date
FROM customer_orders
WHERE last_order_date < latest_order_date - INTERVAL '90 days'
ORDER BY last_order_date ASC;
