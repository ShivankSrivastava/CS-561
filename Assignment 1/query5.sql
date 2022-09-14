with q1 as(
	select distinct prod
	from sales
	group by prod
),
q2 as(
	select q1.prod, max(quant) Q1_MAX
	from q1
	left join sales s
	on q1.prod = s.prod and month between 1 and 3
	group by q1.prod
),
q3 aS(
	select q2.prod, q2.Q1_MAX, CONCAT_WS ('/', month, day , year) Q1_DATE
	from q2
	left join sales s
	on q2.prod = s.prod and q2.Q1_MAX = s.quant
),
q4 as(
	select q3.prod, q3.Q1_MAX, q3.Q1_DATE, max(quant) Q2_MAX
	from q3
	left join sales s
	on q3.prod = s.prod and month between 3 and 6
	group by q3.prod, q3.Q1_MAX, q3.Q1_DATE
),
q5 as(
	select q4.prod, q4.Q1_MAX, q4.Q1_DATE,  q4.Q2_MAX, CONCAT_WS ('/', month, day , year) Q2_DATE
	from q4
	left join sales s
	on q4.prod = s.prod and q4.Q2_MAX = s.quant
),
q6 as(
	select q5.prod, q5.Q1_MAX, q5.Q1_DATE, q5.Q2_MAX, q5.Q2_DATE, max(quant) Q3_MAX
	from q5
	left join sales s
	on q5.prod = s.prod and month between 6 and 9
	group by q5.prod, q5.Q1_MAX, q5.Q1_DATE, q5.Q2_MAX, q5.Q2_DATE
),
q7 as(
	select q6.prod, q6.Q1_MAX, q6.Q1_DATE, q6.Q2_MAX, q6.Q2_DATE,  q6.Q3_MAX, CONCAT_WS ('/', month, day , year) Q3_DATE
	from q6
	left join sales s
	on q6.prod = s.prod and q6.Q3_MAX = s.quant
),
q8 as(
	select q7.prod, q7.Q1_MAX, q7.Q1_DATE, q7.Q2_MAX, q7.Q2_DATE, q7.Q3_MAX, q7.Q3_DATE, max(quant) Q4_MAX
	from q7
	left join sales s
	on q7.prod = s.prod and month between 9 and 12
	group by q7.prod, q7.Q1_MAX, q7.Q1_DATE, q7.Q2_MAX, q7.Q2_DATE, q7.Q3_MAX, q7.Q3_DATE
),
q9 as(
	select q8.prod, q8.Q1_MAX, q8.Q1_DATE, q8.Q2_MAX, q8.Q2_DATE,  q8.Q3_MAX, q8.Q3_DATE, q8.Q4_MAX, CONCAT_WS ('/', month, day , year) Q4_DATE
	from q8
	left join sales s
	on q8.prod = s.prod and q8.Q4_MAX = s.quant
)
	select prod PRODUCT, Q1_MAX, Q1_DATE, Q2_MAX, Q2_DATE,  Q3_MAX, Q3_DATE,  Q4_MAX, Q4_DATE
	from q9
	where Q1_MAX > Q2_MAX or Q1_MAX > Q3_MAX or Q1_MAX > Q4_MAX
	order by prod

