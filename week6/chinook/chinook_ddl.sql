DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_track;
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    is_weekend TINYINT(1) NOT NULL
);

CREATE TABLE dim_customer (
    customer_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    company VARCHAR(80),
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postal_code VARCHAR(10),
    phone VARCHAR(24),
    fax VARCHAR(24),
    email VARCHAR(60) NOT NULL,
    support_rep_id INT,
    support_rep_name VARCHAR(100)
);

CREATE TABLE dim_track (
    track_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    track_id INT NOT NULL,
    track_name VARCHAR(200) NOT NULL,
    album_title VARCHAR(160),
    artist_name VARCHAR(120),
    genre_name VARCHAR(120),
    media_type_name VARCHAR(120),
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT,
    unit_price DECIMAL(10, 2)
);

CREATE TABLE fact_sales (
    sales_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_line_id INT NOT NULL,
    invoice_id INT NOT NULL,
    customer_key BIGINT NOT NULL,
    track_key BIGINT NOT NULL,
    date_key INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,

    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_sales_track FOREIGN KEY (track_key) REFERENCES dim_track(track_key),
    CONSTRAINT fk_sales_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

CREATE INDEX idx_fact_sales_customer ON fact_sales(customer_key);
CREATE INDEX idx_fact_sales_track ON fact_sales(track_key);
CREATE INDEX idx_fact_sales_date ON fact_sales(date_key);
