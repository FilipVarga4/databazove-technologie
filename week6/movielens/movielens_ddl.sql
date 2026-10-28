DROP TABLE IF EXISTS fact_ratings;
DROP TABLE IF EXISTS bridge_movie_genres;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_genres;
DROP TABLE IF EXISTS dim_movies;
DROP TABLE IF EXISTS dim_users;
CREATE TABLE dim_users (
    dim_user_id INT NOT NULL,
    gender CHAR(1) NULL,
    age INT NULL,
    age_group_name VARCHAR(45) NULL,
    occupation_name VARCHAR(255) NULL,
    zip_code VARCHAR(255) NULL,
    PRIMARY KEY (dim_user_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
CREATE TABLE dim_movies (
    dim_movie_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    release_year CHAR(4) NULL,
    PRIMARY KEY (dim_movie_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
CREATE TABLE dim_genres (
    dim_genre_id INT NOT NULL,
    genre_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (dim_genre_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
CREATE TABLE dim_date (
    dim_date_id INT NOT NULL,
    -- YYYYMMDD
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL,
    quarter INT NOT NULL,
    PRIMARY KEY (dim_date_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
CREATE TABLE bridge_movie_genres (
    dim_movie_id INT NOT NULL,
    dim_genre_id INT NOT NULL,
    PRIMARY KEY (dim_movie_id, dim_genre_id),
    CONSTRAINT fk_bridge_movie FOREIGN KEY (dim_movie_id) REFERENCES dim_movies (dim_movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_bridge_genre FOREIGN KEY (dim_genre_id) REFERENCES dim_genres (dim_genre_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
CREATE TABLE fact_ratings (
    fact_rating_id INT NOT NULL,
    dim_user_id INT NOT NULL,
    dim_movie_id INT NOT NULL,
    dim_date_id INT NOT NULL,
    rating INT NOT NULL,
    rated_at DATETIME NOT NULL,
    PRIMARY KEY (fact_rating_id),
    CONSTRAINT fk_ratings_user FOREIGN KEY (dim_user_id) REFERENCES dim_users (dim_user_id),
    CONSTRAINT fk_ratings_movie FOREIGN KEY (dim_movie_id) REFERENCES dim_movies (dim_movie_id),
    CONSTRAINT fk_ratings_date FOREIGN KEY (dim_date_id) REFERENCES dim_date (dim_date_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
