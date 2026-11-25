SELECT
    m.movie_id,
    m.title,
    m.release_year,
    COALESCE(STRING_AGG(g.genre_name, ', ' ORDER BY g.genre_name), 'unknown') AS genre_name
FROM {{ ref('stg_movies') }} m
LEFT JOIN {{ ref('stg_genres_movies') }} gm ON gm.movie_id = m.movie_id
LEFT JOIN {{ ref('stg_genres') }} g ON g.genre_id = gm.genre_id
GROUP BY m.movie_id, m.title, m.release_year
