SELECT 
    *
FROM 
    {{ ref('fct_orders') }} as oi
WHERE 
    oi.total_discount_amount > 0