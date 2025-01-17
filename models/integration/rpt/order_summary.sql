create or replace transient table analytics.RPT.order_summary
         as
        (with final as (
    select c.r_name as region_name, 
    count(*) as order_count , 
    sum(o.o_totalprice) as total_amount
    from analytics.raw.orders o
    inner join analytics.STG.customer_details c on o.o_custkey = c.c_custkey
    group by all
)
select *
from final
        );