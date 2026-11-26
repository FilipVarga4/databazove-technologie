\set ON_ERROR_STOP on
\encoding UTF8

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.categories (
    categoryid INT PRIMARY KEY,
    categoryname VARCHAR(50),
    description VARCHAR(255),
    _source_file TEXT DEFAULT 'categories.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.customers (
    customerid INT PRIMARY KEY,
    customername VARCHAR(100),
    contactname VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(50),
    postalcode VARCHAR(20),
    country VARCHAR(50),
    _source_file TEXT DEFAULT 'customers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.employees (
    employeeid INT PRIMARY KEY,
    lastname VARCHAR(50),
    firstname VARCHAR(50),
    birthdate DATE,
    photo VARCHAR(50),
    notes TEXT,
    _source_file TEXT DEFAULT 'employees.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.shippers (
    shipperid INT PRIMARY KEY,
    shippername VARCHAR(50),
    phone VARCHAR(30),
    _source_file TEXT DEFAULT 'shippers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.suppliers (
    supplierid INT PRIMARY KEY,
    suppliername VARCHAR(100),
    contactname VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(50),
    postalcode VARCHAR(20),
    country VARCHAR(50),
    phone VARCHAR(30),
    _source_file TEXT DEFAULT 'suppliers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.products (
    productid INT PRIMARY KEY,
    productname VARCHAR(100),
    supplierid INT,
    categoryid INT,
    unit VARCHAR(50),
    price DECIMAL(10, 2),
    _source_file TEXT DEFAULT 'products.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.orders (
    orderid INT PRIMARY KEY,
    customerid INT,
    employeeid INT,
    orderdate TIMESTAMP,
    shipperid INT,
    _source_file TEXT DEFAULT 'orders.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.orderdetails (
    orderdetailid INT PRIMARY KEY,
    orderid INT,
    productid INT,
    quantity INT,
    _source_file TEXT DEFAULT 'orderdetails.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

BEGIN;

TRUNCATE TABLE
    bronze.orderdetails,
    bronze.orders,
    bronze.products,
    bronze.suppliers,
    bronze.shippers,
    bronze.employees,
    bronze.customers,
    bronze.categories;

\copy bronze.categories (categoryid, categoryname, description) FROM 'categories.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');
\copy bronze.customers (customerid, customername, contactname, address, city, postalcode, country) FROM 'customers.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');
\copy bronze.employees (employeeid, lastname, firstname, birthdate, photo, notes) FROM 'employees.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');
\copy bronze.shippers (shipperid, shippername, phone) FROM 'shippers.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');
\copy bronze.suppliers (supplierid, suppliername, contactname, address, city, postalcode, country, phone) FROM 'suppliers.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');
\copy bronze.products (productid, productname, supplierid, categoryid, unit, price) FROM 'products.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');
\copy bronze.orders (orderid, customerid, employeeid, orderdate, shipperid) FROM 'orders.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');
\copy bronze.orderdetails (orderdetailid, orderid, productid, quantity) FROM 'orderdetails.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ';');

COMMIT;
