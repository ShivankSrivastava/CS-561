with T1 as(
	select cust, prod, state, round(avg(quant)) as prod_avg
	from sales
	group by cust, prod, state
),
T2 as(
	select T1.cust, T1.prod, T1.state, round(avg(quant)) as other_cust_avg
	from T1, sales as s
	where s.prod = T1.prod and s.state = T1.state and s.cust != T1.cust
	group by T1.cust, T1.prod, T1.state
),
T3 as(
	select T1.cust, T1.prod, T1.state, round(avg(quant)) as other_prod_avg
	from T1, sales as s
	where s.prod != T1.prod and s.state = T1.state and s.cust = T1.cust
	group by T1.cust, T1.prod, T1.state
),
T4 as(
	select T1.cust, T1.prod, T1.state, round(avg(quant)) as other_state_avg
	from T1, sales as s
	where s.prod = T1.prod and s.state != T1.state and s.cust = T1.cust
	group by T1.cust, T1.prod, T1.state
)
select * from T1
left join T2 using(cust, prod, state)
left join T3 using(cust, prod, state)
left join T4 using(cust, prod, state)
order by cust, prod, state