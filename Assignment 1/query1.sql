with T1 as
(
	select cust, min(quant) as MIN_Q, max(quant) as MAX_Q, avg(quant) as AVG_Q
	from sales
	group by cust
),

T2 as 
(
	select T1.cust, T1.MIN_Q, S.prod as MIN_PROD, S.date as MIN_DATE, S.state as ST, T1.MAX_Q, T1.AVG_Q
	from T1, sales as S
	where T1.cust = S.cust and T1.MIN_Q = S.quant
)

select T2.cust, T2.MIN_Q, T2.MIN_PROD, T2.MIN_DATE, T2.ST, T2.MAX_Q, S.prod as MAX_PROD, S.date as MAX_DATE, S.state as ST, T2.AVG_Q 
from T2, sales as S
where T2.cust = S.cust and T2.MAX_Q = S.quant
order by cust;

select * from sales;