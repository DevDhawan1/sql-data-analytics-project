-- CUMULATIVE ANALYSIS
-- CALCULATE THE TOTAL SALES PER MONTH AND THE RUNNING TOTAL OF SALES OVER TIME
select order_month, total_sales, sum(total_sales) over (order by order_month) as running_total_sales, round(avg(avg_price) over(order by order_month), 0) as moving_average_price
from 
(
select date_format(order_date, '%Y-%m') as order_month, sum(sales_amount) as total_sales, round(avg(price), 0) as avg_price
from fact_sales
where order_date is not null
group by order_month
) 
as monthly_sales;