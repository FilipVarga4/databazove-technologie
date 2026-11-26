SELECT
    q AS id,
    q AS quarter,
    'Q' || q::TEXT AS quarter_name
FROM GENERATE_SERIES(1, 4) AS gs(q)
