-- ANALYSE THE YEARLY SALES TRENDS 
select year(order_date) as order_year, sum(sales_amount) as total_sales, count(distinct(customer_key)) as total_customers, sum(quantity) as total_quantity
from fact_sales
where order_date is not null
group by order_year
order by order_year;

-- ANALYSE THE MONTHLY SALES TRENDS 
select year(order_date) as order_year, month(order_date) as order_month, sum(sales_amount) as total_sales, count(distinct(customer_key)) as total_customers, sum(quantity) as total_quantity
from fact_sales
where order_date is not null
group by order_year, order_month
order by order_year, order_month;
-- ALTERNATE METHOD
select date_format(order_date, '%M %Y') as order_month, sum(sales_amount) as total_sales, count(distinct(customer_key)) as total_customers, sum(quantity) as total_quantity
from fact_sales
where order_date is not null
group by order_month
order by order_month;