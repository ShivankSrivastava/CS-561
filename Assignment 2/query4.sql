with T1 as(
Select cust, prod, quant AS QUANTITY, max(date) as DATE
from sales
where state ='NJ'
group by cust, prod, quant
ORDER BY cust, quant desc
),
T2 AS(
Select  T1.cust as CUSTOMER, T1.QUANTITY, T1.prod as PRODUCT , max(T1.DATE) as DATE, count(distinct B.QUANTITY) +1 as rank_quant
from T1
left join T1 as B on T1.cust = B.cust AND B.QUANTITY > T1.QUANTITY
group by T1.cust, T1.prod, T1.QUANTITY
having count(distinct B.QUANTITY) +1 <= 3
order by T1.cust, T1.QUANTITY desc
)

SELECT T2.CUSTOMER, T2.QUANTITY, T2.PRODUCT, T2.DATE from T2
