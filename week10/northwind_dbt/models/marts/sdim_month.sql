SELECT
    m AS id,
    m AS month,
    TRIM(TO_CHAR(MAKE_DATE(2000, m, 1), 'Month')) AS month_name
FROM GENERATE_SERIES(1, 12) AS gs(m)
