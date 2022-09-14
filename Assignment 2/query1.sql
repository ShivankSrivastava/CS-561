with T1 as(
	select distinct cust, prod, month
	from sales
	group by cust, prod, month
	order by cust, prod, month
),

T2 as (
	select T1.cust, T1.prod, T1.month, round(avg(quant)) as BEFORE_AVG
    from T1, sales as s
    where T1.cust = s.cust and T1.prod = s.prod and T1.month = s.month + 1
    group by T1.cust, T1.prod, T1.month
),

T3 as (
	select T1.cust, T1.prod, T1.month, round(avg(quant)) as AFTER_AVG
    from T1, sales as s
    where T1.cust = s.cust and T1.prod = s.prod and T1.month = s.month - 1
    group by T1.cust, T1.prod, T1.month
),

T4 as (
	select T1.cust, T1.prod, T1.month, T2.BEFORE_AVG
	from T1 LEFT JOIN T2
    on T1.cust = T2.cust and T1.prod = T2.prod and T1.month = T2.month 
),

T5 as (
	select T1.cust, T1.prod, T1.month, T3.AFTER_AVG
	from T1 LEFT JOIN T3
    on T1.cust = T3.cust and T1.prod = T3.prod and T1.month = T3.month 
),

T6 as (
	select T4.cust, T4.prod, T4.month, T4.BEFORE_AVG, T5.AFTER_AVG
    from T4 LEFT JOIN T5
    on T4.cust = T5.cust and T4.prod = T5.prod and T4.month = T5.month 
),

T7 as (
	select T6.cust, T6.prod, T6.month, s.quant
	from T6 left join sales s
	on T6.cust = s.cust and T6.prod = s.prod and T6.month = s.month and
	s.quant between T6.BEFORE_AVG and T6.AFTER_AVG
)

select T7.cust CUSTOMER, T7.prod PRODUCT, T7.month, count(T7.quant) SALES_COUNT_BETWEEN_AVGS
from T7
group by T7.cust, T7.prod, T7.month
order by T7.cust, T7.prod, T7.month