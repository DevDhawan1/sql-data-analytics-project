/*
============================================================
Product Report
============================================================
Purpose:
 - This report consolidates key product metrics and behaviors.
Highlights:
1. Gathers essential fields such as product name, category, subcategory, and ...
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low...
3. Aggregates product-level metrics:
   - total orders
   - total sales
   - total quantity sold
   - total customers (unique)
   - lifespan (in months)
4. Calculates valuable KPIs:
   - recency (months since last sale)
   - average order revenue (AOR)
   - average monthly revenue
============================================================
*/

create view report_products as 
with base_query as (
-- BASE QUERY - RETRIEVES CORE COLUMNS FROM THE TABLES
select s.order_number, 
s.customer_key, 
s.order_date, 
s.sales_amount, 
s.quantity, 
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
from fact_sales s
left join dim_products p
on s.product_key = p.product_key
where order_date is not null)
, product_aggregation AS (
-- CUSTOMER AGGREGATION - Summarizes key metrics at the column level 
select product_key, 
product_name,
category,
subcategory, 
cost,
count(distinct(order_number)) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity, 
count(distinct(customer_key)) as total_customers,
max(order_date) as last_sale_date,
period_diff(date_format(max(order_date),'%Y%m'), date_format(min(order_date), '%Y%m')) as lifespan,
ROUND(AVG(CAST(sales_amount AS DECIMAL(10,2)) / NULLIF(quantity, 0)), 1) AS avg_selling_price
from base_query
group by  product_key, product_name, category, subcategory, cost
)
select  product_key, 
product_name,
category,
subcategory, 
cost,
last_sale_date,
period_diff(date_format(current_date,'%Y%m'), date_format(last_sale_date, '%Y%m')) as recency_in_months,
case
	when total_sales > 50000 then 'High-Performer'
    when total_sales >= 10000 then 'Mid-Range'
    else 'Low-Performer' 
end as product_segment,
lifespan,
total_orders,
total_sales,
total_quantity, 
total_customers,
avg_selling_price,
case when total_orders = 0 then 0
	else round((total_sales/total_orders),2) 
end as avg_order_value,
case when lifespan = 0 then total_sales
	else round(total_sales / lifespan, 2)
end as avg_monthly_spend
from product_aggregation;


select *
from report_products;





