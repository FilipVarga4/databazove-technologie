SELECT
    TO_CHAR(MAKE_INTERVAL(secs => sec), 'HH24MISS')::INT AS id,
    MAKE_TIME(sec / 3600, (sec / 60) % 60, sec % 60) AS full_time,
    sec % 60 AS second,
    (sec / 60) % 60 AS minute,
    CASE
        WHEN sec / 3600 BETWEEN 5 AND 11 THEN 1
        WHEN sec / 3600 BETWEEN 12 AND 17 THEN 2
        WHEN sec / 3600 BETWEEN 18 AND 21 THEN 3
        ELSE 4
    END AS sdim_daypart_id,
    sec / 3600 AS sdim_hour_id
FROM GENERATE_SERIES(0, 86399) AS gs(sec)
