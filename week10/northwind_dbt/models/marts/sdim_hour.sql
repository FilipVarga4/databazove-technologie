SELECT
    h AS id,
    h AS hour,
    CASE WHEN h % 12 = 0 THEN 12 ELSE h % 12 END AS hour_12,
    CASE WHEN h < 12 THEN 'AM' ELSE 'PM' END AS am_pm
FROM GENERATE_SERIES(0, 23) AS gs(h)
