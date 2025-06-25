SELECT 
    orders.*, 
    order_items_summary.total_extended_price,
    order_items_summary.total_discount_amount
FROM 
    {{ ref('stg_tpch_orders') }} as orders 
JOIN
    {{ ref('int_order_items_summary') }} as order_items_summary
ON
    orders.order_key = order_items_summary.order_key
ORDER BY
    orders.order_date DESC