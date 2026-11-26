\set ON_ERROR_STOP on
\encoding UTF8

CREATE SCHEMA IF NOT EXISTS gold;

CREATE TABLE IF NOT EXISTS gold.sdim_country (
    id INT PRIMARY KEY,
    country_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.sdim_city (
    id INT PRIMARY KEY,
    city_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.sdim_category (
    id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.sdim_supplier (
    id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS gold.sdim_quarter (
    id INT PRIMARY KEY,
    quarter INT NOT NULL,
    quarter_name VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.sdim_month (
    id INT PRIMARY KEY,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.sdim_daypart (
    id INT PRIMARY KEY,
    part_of_day VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.sdim_hour (
    id INT PRIMARY KEY,
    hour INT NOT NULL,
    hour_12 INT NOT NULL,
    am_pm VARCHAR(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_customers (
    id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    address VARCHAR(100),
    sdim_city_id INT REFERENCES gold.sdim_city(id),
    sdim_country_id INT REFERENCES gold.sdim_country(id)
);

CREATE TABLE IF NOT EXISTS gold.dim_product (
    id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_unit VARCHAR(50),
    sdim_category_id INT REFERENCES gold.sdim_category(id),
    sdim_supplier_id INT REFERENCES gold.sdim_supplier(id)
);

CREATE TABLE IF NOT EXISTS gold.dim_employees (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE
);

CREATE TABLE IF NOT EXISTS gold.dim_shipper (
    id INT PRIMARY KEY,
    shipper_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_date (
    id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    weekday INT NOT NULL,
    week INT NOT NULL,
    year INT NOT NULL,
    sdim_quarter_id INT NOT NULL REFERENCES gold.sdim_quarter(id),
    sdim_month_id INT NOT NULL REFERENCES gold.sdim_month(id)
);

CREATE TABLE IF NOT EXISTS gold.dim_time (
    id INT PRIMARY KEY,
    full_time TIME NOT NULL,
    second INT NOT NULL,
    minute INT NOT NULL,
    sdim_daypart_id INT NOT NULL REFERENCES gold.sdim_daypart(id),
    sdim_hour_id INT NOT NULL REFERENCES gold.sdim_hour(id)
);

CREATE TABLE IF NOT EXISTS gold.fact_orders (
    id INT PRIMARY KEY,
    quantity INT NOT NULL,
    sales_amount DECIMAL(10, 2) NOT NULL,
    prod_price DECIMAL(10, 2) NOT NULL,
    date_id INT NOT NULL REFERENCES gold.dim_date(id),
    time_id INT NOT NULL REFERENCES gold.dim_time(id),
    customer_id INT NOT NULL REFERENCES gold.dim_customers(id),
    product_id INT NOT NULL REFERENCES gold.dim_product(id),
    employee_id INT NOT NULL REFERENCES gold.dim_employees(id),
    shipper_id INT NOT NULL REFERENCES gold.dim_shipper(id)
);

CREATE INDEX IF NOT EXISTS idx_fact_orders_date_id ON gold.fact_orders(date_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_time_id ON gold.fact_orders(time_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_customer_id ON gold.fact_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_product_id ON gold.fact_orders(product_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_employee_id ON gold.fact_orders(employee_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_shipper_id ON gold.fact_orders(shipper_id);

BEGIN;

TRUNCATE TABLE
    gold.fact_orders,
    gold.dim_customers,
    gold.dim_product,
    gold.dim_employees,
    gold.dim_shipper,
    gold.dim_date,
    gold.dim_time,
    gold.sdim_country,
    gold.sdim_city,
    gold.sdim_category,
    gold.sdim_supplier,
    gold.sdim_quarter,
    gold.sdim_month,
    gold.sdim_daypart,
    gold.sdim_hour;

INSERT INTO gold.sdim_country (id, country_name)
SELECT DISTINCT
    DENSE_RANK() OVER (ORDER BY country)::INT AS id,
    country
FROM silver.stg_customers
WHERE country IS NOT NULL
ORDER BY id;

INSERT INTO gold.sdim_city (id, city_name)
SELECT DISTINCT
    DENSE_RANK() OVER (ORDER BY city)::INT AS id,
    city
FROM silver.stg_customers
WHERE city IS NOT NULL
ORDER BY id;

INSERT INTO gold.sdim_category (id, category_name)
SELECT category_id, category_name
FROM silver.stg_categories
ORDER BY category_id;

INSERT INTO gold.sdim_supplier (id, supplier_name, contact_name, city, country)
SELECT supplier_id, supplier_name, contact_name, city, country
FROM silver.stg_suppliers
ORDER BY supplier_id;

INSERT INTO gold.sdim_quarter (id, quarter, quarter_name)
SELECT q, q, 'Q' || q::TEXT
FROM GENERATE_SERIES(1, 4) AS gs(q);

INSERT INTO gold.sdim_month (id, month, month_name)
SELECT m, m, TRIM(TO_CHAR(MAKE_DATE(2000, m, 1), 'Month'))
FROM GENERATE_SERIES(1, 12) AS gs(m);

INSERT INTO gold.sdim_daypart (id, part_of_day) VALUES
    (1, 'morning'),
    (2, 'afternoon'),
    (3, 'evening'),
    (4, 'night');

INSERT INTO gold.sdim_hour (id, hour, hour_12, am_pm)
SELECT
    h,
    h,
    CASE WHEN h % 12 = 0 THEN 12 ELSE h % 12 END,
    CASE WHEN h < 12 THEN 'AM' ELSE 'PM' END
FROM GENERATE_SERIES(0, 23) AS gs(h);

INSERT INTO gold.dim_customers (id, customer_name, contact_name, address, sdim_city_id, sdim_country_id)
SELECT
    c.customer_id,
    c.customer_name,
    c.contact_name,
    c.address,
    ci.id,
    co.id
FROM silver.stg_customers c
LEFT JOIN gold.sdim_city ci ON ci.city_name = c.city
LEFT JOIN gold.sdim_country co ON co.country_name = c.country
ORDER BY c.customer_id;

INSERT INTO gold.dim_product (id, product_name, product_unit, sdim_category_id, sdim_supplier_id)
SELECT
    p.product_id,
    p.product_name,
    p.product_unit,
    p.category_id,
    p.supplier_id
FROM silver.stg_products p
ORDER BY p.product_id;

INSERT INTO gold.dim_employees (id, first_name, last_name, birth_date)
SELECT employee_id, first_name, last_name, birth_date
FROM silver.stg_employees
ORDER BY employee_id;

INSERT INTO gold.dim_shipper (id, shipper_name)
SELECT shipper_id, shipper_name
FROM silver.stg_shippers
ORDER BY shipper_id;

INSERT INTO gold.dim_date (id, full_date, day, weekday, week, year, sdim_quarter_id, sdim_month_id)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT,
    d,
    EXTRACT(DAY FROM d)::INT,
    EXTRACT(ISODOW FROM d)::INT,
    EXTRACT(WEEK FROM d)::INT,
    EXTRACT(YEAR FROM d)::INT,
    EXTRACT(QUARTER FROM d)::INT,
    EXTRACT(MONTH FROM d)::INT
FROM GENERATE_SERIES(
    (SELECT MIN(order_date)::DATE FROM silver.stg_orders),
    (SELECT MAX(order_date)::DATE FROM silver.stg_orders),
    INTERVAL '1 day'
) AS gs(d);

INSERT INTO gold.dim_time (id, full_time, second, minute, sdim_daypart_id, sdim_hour_id)
SELECT
    TO_CHAR(MAKE_INTERVAL(secs => sec), 'HH24MISS')::INT,
    MAKE_TIME(sec / 3600, (sec / 60) % 60, sec % 60),
    sec % 60,
    (sec / 60) % 60,
    CASE
        WHEN sec / 3600 BETWEEN 5 AND 11 THEN 1
        WHEN sec / 3600 BETWEEN 12 AND 17 THEN 2
        WHEN sec / 3600 BETWEEN 18 AND 21 THEN 3
        ELSE 4
    END,
    sec / 3600
FROM GENERATE_SERIES(0, 86399) AS gs(sec);

INSERT INTO gold.fact_orders (
    id, quantity, sales_amount, prod_price, date_id, time_id, customer_id, product_id, employee_id, shipper_id
)
SELECT
    od.order_detail_id,
    od.quantity,
    (od.quantity * p.price)::DECIMAL(10, 2),
    p.price,
    TO_CHAR(o.order_date, 'YYYYMMDD')::INT,
    TO_CHAR(o.order_date, 'HH24MISS')::INT,
    o.customer_id,
    od.product_id,
    o.employee_id,
    o.shipper_id
FROM silver.stg_orderdetails od
JOIN silver.stg_orders o ON o.order_id = od.order_id
JOIN silver.stg_products p ON p.product_id = od.product_id
ORDER BY od.order_detail_id;

COMMIT;
