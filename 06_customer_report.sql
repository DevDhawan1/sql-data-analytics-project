/*
Customer Report
Purpose:
- This report consolidates key customer metrics and behaviors
Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last order)
   - average order value
   - average monthly spend
*/
create view report_customers as 
with base_query as (
-- BASE QUERY - RETRIEVES CORE COLUMNS FROM THE TABLES
select s.order_number, 
s.product_key, 
s.order_date, 
s.sales_amount, 
s.quantity, 
c.customer_key, 
c.customer_number,
timestampdiff(year, birthdate, current_date) as age,
concat(c.first_name, ' ', c.last_name) as customer_name
from fact_sales s
left join dim_customers c
on s.customer_key = c.customer_key 
where order_date is not null)
, customer_aggregation AS (
-- CUSTOMER AGGREGATION - Summarizes key metrics at the column level 
select customer_key, 
customer_number,
customer_name,
age,
count(distinct(order_number)) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity, 
count(distinct(product_key)) as total_products,
max(order_date) as last_order_date,
period_diff(date_format(max(order_date),'%Y%m'), date_format(min(order_date), '%Y%m')) as lifespan
from base_query
group by customer_key, customer_number, customer_name, age
)
select customer_key, 
customer_number,
customer_name,
age,
case
	when lifespan >= 12 and total_sales > 5000 then 'VIP'
    when lifespan >= 12 and total_sales <= 5000 then 'Regular'
    else 'New' 
end as customer_segment,
last_order_date,
period_diff(date_format(current_date, '%Y%m'), date_format(last_order_date, '%Y%m')) as recency,
total_orders,
total_sales,
total_quantity, 
total_products,
lifespan,
case when total_orders = 0 then 0
	else round((total_sales/total_orders),2) 
end as avg_order_value,
case when lifespan = 0 then total_sales
	else round(total_sales / lifespan, 2)
end as avg_monthly_spend
from customer_aggregation;


select *
from report_customers;