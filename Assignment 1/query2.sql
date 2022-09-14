with T1 as(
	select year, month, day, sum(quant) as SUM_QUANT
	from sales
	group by year, month, day
	order by year, month, day
),
T2 as(
	select year, month, max(SUM_QUANT) as BUSIEST_TOTAL_Q, min(SUM_QUANT) as SLOWEST_TOTAL_Q
	from T1
	group by year, month
	order by year, month
),
T3 as(
	select T2.year, T2.month, T1.day as BUSIEST_DAY, T2.BUSIEST_TOTAL_Q, T2.SLOWEST_TOTAL_Q
	from T1, T2
	where T1.year = T2.year and T1.month = T2.month and T1.SUM_QUANT = T2.BUSIEST_TOTAL_Q
)
	select T3.year, T3.month, T3.BUSIEST_DAY, T3.BUSIEST_TOTAL_Q, T1.day as SLOWEST_DAY, T3.SLOWEST_TOTAL_Q
	from T3,T1
	where T1.year = T3.year and T1.month = T3.month and T1.SUM_QUANT = SLOWEST_TOTAL_Q
