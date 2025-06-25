SELECT 
    {{
        dbt_utils.generate_surrogate_key([
            'l_orderkey',
            'l_linenumber'
        ]) 
    }} AS surrogate_key , -- Tạo surrogate key từ các trường
    l_orderkey AS order_key,
    l_partkey AS part_key,
    l_linenumber AS line_number,
    l_quantity AS quantity,
    l_extendedprice AS extended_price,
    l_discount AS discount,
    l_tax AS tax
FROM 
    {{ source('tpch', 'lineitem') }} l