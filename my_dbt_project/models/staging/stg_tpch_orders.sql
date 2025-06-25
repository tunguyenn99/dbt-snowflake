SELECT
    o.o_orderkey AS order_key,
    o.o_custkey AS customer_key,
    o.o_orderstatus AS order_status,
    o.o_totalprice AS total_price,
    o.o_orderdate AS order_date
FROM 
    {{ source('tpch', 'orders') }} as o