SELECT 
    li.order_key,
    li.part_key,
    li.line_number,
    li.extended_price,
    o.customer_key,
    o.order_status,
    o.total_price,
    o.order_date, 
    {{ discounted_amount('li.extended_price', 'li.discount') }} AS discounted_price,
FROM 
    {{ ref('stg_tpch_lineitem') }} as li
JOIN 
    {{ ref('stg_tpch_orders') }} as o
ON
    o.order_key = li.order_key
ORDER BY 
    o.order_date DESC