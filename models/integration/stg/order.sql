{{
    config(
        materialized="table",
        alias="order_details",
        schema="STG"
    )
}}

with final as (
    select 
        o.o_orderkey,
        o.o_custkey,
        o.o_orderstatus,
        o.o_totalprice,
        o.o_orderdate,
        o.o_orderpriority,
        o.o_clerk,
        o.o_shippriority,
        c.c_name as customer_name,
        c.c_phone as customer_phone,
        p.p_name as product_name,
        p.p_category as product_category
    from {{ source('my_project', 'orders') }} o
    inner join {{ source('my_project', 'customer') }} c on o.o_custkey = c.c_custkey
    inner join {{ source('my_project', 'order_items') }} oi on o.o_orderkey = oi.o_orderkey
    inner join {{ source('my_project', 'products') }} p on oi.i_partkey = p.p_partkey
)

select *
from final
