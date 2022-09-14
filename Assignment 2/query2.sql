with T1 as(
	select distinct cust, prod, month, round(avg(quant)) as DURING_AVG
	from sales
	group by cust, prod, month
	order by cust, prod, month
),
T2 as(
	select T1.cust, T1.prod, T1.month, T1.DURING_AVG, round(avg(quant)) as BEFORE_AVG
	from T1, sales s
	where T1.cust = s.cust and T1.prod = s.prod and T1.month = s.month + 1
	group by T1.cust, T1.prod, T1.month, T1.DURING_AVG
),
T3 as(
	select T1.cust, T1.prod, T1.month, T1.DURING_AVG, round(avg(quant)) as AFTER_AVG
	from T1, sales s
	where T1.cust = s.cust and T1.prod = s.prod and T1.month = s.month - 1
	group by T1.cust, T1.prod, T1.month, T1.DURING_AVG
),
T4 as(
	SELECT T1.cust, T1.prod, T1.month, T1.DURING_AVG, BEFORE_AVG
	FROM T1 
	LEFT JOIN T2 
	ON T1.cust = T2.cust and T1.prod = T2.prod and T1.month = T2.month
	group by T1.cust, T1.prod, T1.month, T1.DURING_AVG, T2.BEFORE_AVG
),
T5 as(
	SELECT T1.cust, T1.prod, T1.month, T1.DURING_AVG, AFTER_AVG
	FROM T1 
	LEFT JOIN T3 
	ON T1.cust = T3.cust and T1.prod = T3.prod and T1.month = T3.month
	group by T1.cust, T1.prod, T1.month, T1.DURING_AVG, T3.AFTER_AVG
),
T6 as(
	select T4.cust, T4.prod, T4.month, T4.before_avg, T4.during_avg, after_avg
	from T4, T5
	where T4.cust = T5.cust and T4.prod = T5.prod and T4.month = T5.month
)
select T6.cust CUSTOMER, T6.prod PRODUCT, T6.month, T6.before_avg, T6.during_avg, T6.after_avg
from T6
group by cust, prod, month, before_avg, during_avg, after_avg
