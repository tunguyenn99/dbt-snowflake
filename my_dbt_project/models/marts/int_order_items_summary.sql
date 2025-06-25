SELECT 
    li. order_key, 
    sum(extended_price) as total_extended_price,
    sum(discounted_price) as total_discount_amount
FROM 
    {{ ref('int_order_items') }} as li
GROUP BY 
    li.order_key