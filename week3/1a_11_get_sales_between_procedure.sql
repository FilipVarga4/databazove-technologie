CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC(12, 2);
BEGIN
    SELECT SUM(sales)
    INTO v_total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Start Date: %, End Date: %, Total Sales: %', start_date, end_date, COALESCE(v_total_sales, 0);
END;
$$;