DROP TABLE IF EXISTS fact_invoice_lines;
DROP TABLE IF EXISTS dim_tracks;
DROP TABLE IF EXISTS dim_customers;
DROP TABLE IF EXISTS dim_employees;
DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_tracks (
    dim_track_id INT NOT NULL,
    track_name VARCHAR(200) NOT NULL,
    album_title VARCHAR(160) NULL,
    artist_name VARCHAR(120) NULL,
    genre_name VARCHAR(120) NULL,
    media_type_name VARCHAR(120) NULL,
    composer VARCHAR(220) NULL,
    milliseconds INT NULL,
    bytes INT NULL,
    PRIMARY KEY (dim_track_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE dim_customers (
    dim_customer_id INT NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    company VARCHAR(80) NULL,
    address VARCHAR(70) NULL,
    city VARCHAR(40) NULL,
    state VARCHAR(40) NULL,
    country VARCHAR(40) NULL,
    postal_code VARCHAR(10) NULL,
    phone VARCHAR(24) NULL,
    email VARCHAR(60) NOT NULL,
    PRIMARY KEY (dim_customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE dim_employees (
    dim_employee_id INT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    title VARCHAR(30) NULL,
    email VARCHAR(60) NULL,
    city VARCHAR(40) NULL,
    country VARCHAR(40) NULL,
    PRIMARY KEY (dim_employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE dim_date (
    dim_date_id INT NOT NULL,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL,
    quarter INT NOT NULL,
    PRIMARY KEY (dim_date_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fact_invoice_lines (
    fact_invoice_line_id INT NOT NULL,
    invoice_id INT NOT NULL,
    dim_track_id INT NOT NULL,
    dim_customer_id INT NOT NULL,
    dim_employee_id INT NULL,
    dim_date_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    line_total DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (fact_invoice_line_id),
    CONSTRAINT fk_fact_track FOREIGN KEY (dim_track_id) REFERENCES dim_tracks (dim_track_id),
    CONSTRAINT fk_fact_customer FOREIGN KEY (dim_customer_id) REFERENCES dim_customers (dim_customer_id),
    CONSTRAINT fk_fact_employee FOREIGN KEY (dim_employee_id) REFERENCES dim_employees (dim_employee_id),
    CONSTRAINT fk_fact_date FOREIGN KEY (dim_date_id) REFERENCES dim_date (dim_date_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
