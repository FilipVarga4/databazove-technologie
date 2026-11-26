SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS id,
    d AS full_date,
    EXTRACT(DAY FROM d)::INT AS day,
    EXTRACT(ISODOW FROM d)::INT AS weekday,
    EXTRACT(WEEK FROM d)::INT AS week,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(QUARTER FROM d)::INT AS sdim_quarter_id,
    EXTRACT(MONTH FROM d)::INT AS sdim_month_id
FROM GENERATE_SERIES(
    (SELECT MIN(order_date)::DATE FROM {{ ref('stg_orders') }}),
    (SELECT MAX(order_date)::DATE FROM {{ ref('stg_orders') }}),
    INTERVAL '1 day'
) AS gs(d)
