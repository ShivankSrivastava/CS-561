with T1 as(
	select cust, prod, month, sum(quant) as SUM_QUANT
	from sales
	group by cust, prod, month
),
T2 as (
	select T1.cust, T1.month, max(SUM_QUANT) as MAX_QUANT, min(SUM_QUANT) as MIN_QUANT
	from T1
	group by T1.cust, T1.month
),
T3 as (
	select T1.cust, T1.month, T1.prod as MOST_FAV_PROD 
	from T1,T2
	where T2.MAX_QUANT = T1.SUM_QUANT and T1.cust = T2.cust and T1.month = T2.month
),
T4 as (
	select T1.cust, T1.month, T1.prod as LEAST_FAV_PROD 
	from T1,T2
	where T2.MIN_QUANT = T1.SUM_QUANT and T1.cust = T2.cust and T1.month = T2.month
),
T5 as(
	select T3.cust, T3.month, T3.MOST_FAV_PROD, T4.LEAST_FAV_PROD
	from T3,T4
	where T3.cust = T4.cust and T3.month = T4.month 
)
	select cust as CUSTOMER, month as MONTH, MOST_FAV_PROD, LEAST_FAV_PROD
	from T5
    
