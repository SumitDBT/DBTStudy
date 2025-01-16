{{ 
    config(
        materialized="table",
        alias="customer_order_status",
        schema="STG"
    )
}}

with customer_orders as (
    select 
        o.o_orderkey,
        o.o_custkey,
        o.o_orderstatus,
        o.o_orderdate,
        o.o_totalprice,
        count(li.l_orderkey) as item_count
    from 
        {{ source('my_project', 'orders') }} o
    inner join 
        {{ source('my_project', 'lineitem') }} li on o.o_orderkey = li.l_orderkey
    group by 
        o.o_orderkey, o.o_custkey, o.o_orderstatus, o.o_orderdate, o.o_totalprice
)

select 
    co.o_custkey,
    co.o_orderkey,
    co.o_orderstatus,
    co.o_orderdate,
    co.o_totalprice,
    co.item_count
from 
    customer_orders co
where 
    co.o_orderstatus = 'O'; 

