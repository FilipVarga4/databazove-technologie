WITH RECURSIVE date_range AS (
    SELECT 
        MIN(sale_date) AS min_date,
        MAX(sale_date) AS max_date
    FROM flourmills_sales
),
calendar AS (
    SELECT min_date AS sale_date, max_date
    FROM date_range
    UNION ALL
    SELECT (sale_date + INTERVAL '1 day')::DATE, max_date
    FROM calendar
    WHERE sale_date < max_date
)
SELECT sale_date
FROM calendar
ORDER BY sale_date ASC;