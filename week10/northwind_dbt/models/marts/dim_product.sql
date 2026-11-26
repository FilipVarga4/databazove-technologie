SELECT
    p.product_id AS id,
    p.product_name,
    p.product_unit,
    cat.id AS sdim_category_id,
    sup.id AS sdim_supplier_id
FROM {{ ref('stg_products') }} p
LEFT JOIN {{ ref('sdim_category') }} cat ON cat.id = p.category_id
LEFT JOIN {{ ref('sdim_supplier') }} sup ON sup.id = p.supplier_id
