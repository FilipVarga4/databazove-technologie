\set ON_ERROR_STOP on
\encoding UTF8

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.categories (
    categoryid TEXT,
    categoryname TEXT,
    description TEXT,
    _source_file TEXT DEFAULT 'categories.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.customers (
    customerid TEXT,
    customername TEXT,
    contactname TEXT,
    address TEXT,
    city TEXT,
    postalcode TEXT,
    country TEXT,
    _source_file TEXT DEFAULT 'customers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.employees (
    employeeid TEXT,
    lastname TEXT,
    firstname TEXT,
    birthdate TEXT,
    photo TEXT,
    notes TEXT,
    _source_file TEXT DEFAULT 'employees.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.shippers (
    shipperid TEXT,
    shippername TEXT,
    phone TEXT,
    _source_file TEXT DEFAULT 'shippers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.suppliers (
    supplierid TEXT,
    suppliername TEXT,
    contactname TEXT,
    address TEXT,
    city TEXT,
    postalcode TEXT,
    country TEXT,
    phone TEXT,
    _source_file TEXT DEFAULT 'suppliers.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.products (
    productid TEXT,
    productname TEXT,
    supplierid TEXT,
    categoryid TEXT,
    unit TEXT,
    price TEXT,
    _source_file TEXT DEFAULT 'products.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.orders (
    orderid TEXT,
    customerid TEXT,
    employeeid TEXT,
    orderdate TEXT,
    shipperid TEXT,
    _source_file TEXT DEFAULT 'orders.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS bronze.orderdetails (
    orderdetailid TEXT,
    orderid TEXT,
    productid TEXT,
    quantity TEXT,
    _source_file TEXT DEFAULT 'orderdetails.csv',
    _loaded_at TIMESTAMPTZ DEFAULT now()
);

BEGIN;

TRUNCATE TABLE
    bronze.categories,
    bronze.customers,
    bronze.employees,
    bronze.shippers,
    bronze.suppliers,
    bronze.products,
    bronze.orders,
    bronze.orderdetails;

\copy bronze.categories (categoryid, categoryname, description) FROM 'data/categories.csv' WITH (FORMAT CSV, HEADER TRUE);
\copy bronze.customers (customerid, customername, contactname, address, city, postalcode, country) FROM 'data/customers.csv' WITH (FORMAT CSV, HEADER TRUE);
\copy bronze.employees (employeeid, lastname, firstname, birthdate, photo, notes) FROM 'data/employees.csv' WITH (FORMAT CSV, HEADER TRUE);
\copy bronze.shippers (shipperid, shippername, phone) FROM 'data/shippers.csv' WITH (FORMAT CSV, HEADER TRUE);
\copy bronze.suppliers (supplierid, suppliername, contactname, address, city, postalcode, country, phone) FROM 'data/suppliers.csv' WITH (FORMAT CSV, HEADER TRUE);
\copy bronze.products (productid, productname, supplierid, categoryid, unit, price) FROM 'data/products.csv' WITH (FORMAT CSV, HEADER TRUE);
\copy bronze.orders (orderid, customerid, employeeid, orderdate, shipperid) FROM 'data/orders.csv' WITH (FORMAT CSV, HEADER TRUE);
\copy bronze.orderdetails (orderdetailid, orderid, productid, quantity) FROM 'data/orderdetails.csv' WITH (FORMAT CSV, HEADER TRUE);

COMMIT;
