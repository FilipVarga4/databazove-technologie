CREATE OR REPLACE PROCEDURE apply_regional_discount(
    region_name VARCHAR,
    discount_rate NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET sales = sales * (1 - discount_rate)
    WHERE region = region_name;

    RAISE NOTICE 'Applied discount of % to region %', discount_rate, region_name;
END;
$$;