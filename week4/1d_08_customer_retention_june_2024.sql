WITH customer_first_purchase AS (
    SELECT customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS first_month
    FROM orders
    GROUP BY customer_id
)
SELECT COUNT(DISTINCT cfp.customer_id)
FROM customer_first_purchase cfp
WHERE cfp.first_month = '2024-06-01'
    AND EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.customer_id = cfp.customer_id
            AND DATE_TRUNC('month', o.order_date) > cfp.first_month
    );
