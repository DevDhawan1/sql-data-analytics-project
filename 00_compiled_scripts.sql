update fact_sales
set order_date = null
where order_date = '';

select *
from fact_sales;

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

-- PERFORMANCE ANALYSIS - COMPARE CURRENT VALUE WITH TARGET VALUE
with yearly_product_sales as (
select year(f.order_date) as order_year, p.product_name, sum(f.sales_amount) as current_sales
from fact_sales f
join dim_products p
on f.product_key = p.product_key
where order_date is not null
group by order_year, product_name
order by order_year
)
select order_year, product_name, current_sales, round(avg(current_sales) over (partition by product_name)) as avg_sales, (current_sales - round(avg(current_sales) over (partition by product_name))) as diff_avg, 
case 
when (current_sales - round(avg(current_sales) over (partition by product_name))) > 1 then 'Above Average'
when (current_sales - round(avg(current_sales) over (partition by product_name))) < 1 then 'Below Average'
else 'Average'
end as avg_change,
-- Year-over-year analysis
lag(current_sales) over (partition by product_name order by order_year) prev_yr_sales,
current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_prev_yr,
case 
when (current_sales - lag(current_sales) over (partition by product_name order by order_year)) > 1 then 'Increase'
when (current_sales - lag(current_sales) over (partition by product_name order by order_year)) < 1 then 'Decrease'
else 'No Change'
end as prev_yr_change
from yearly_product_sales
order by product_name, order_year;

-- PART TO WHOLE ANALYSIS - which category contributes the most to overall sales?
with category_sales as (
select category, sum(sales_amount) as total_sales
from fact_sales f
left join dim_products p
on f.product_key = p.product_key
group by category)
select category, total_sales, sum(total_sales) over () as overall_sales, concat(round((total_sales / sum(total_sales) over())*100 , 2), '%') as percent_of_total
from category_sales
order by total_sales desc;

-- DATA SEGMENTATION - Segment products into cost ranges and count how many products fall into each category
with product_segment as (
select product_key, product_name, cost,
case 
when cost < 100 then 'Below 100'
when cost between 100 and 500 then '100-500'
when cost between 500 and 1000 then '500-1000'
else 'Above 1000' 
end as cost_range
from dim_products)
select cost_range, count(product_key) as total_products
from product_segment
group by cost_range
order by total_products desc;

select * 
from dim_customers;
select * 
from fact_sales where customer_key = 1;
-- GROUP CUSTOMERS BASED ON SPENDING BEHAVIOUR
with customer_spending as (
select c.customer_key, 
sum(s.sales_amount) as total_spending,
min(s.order_date) as first_order,
max(s.order_date) as last_order,
period_diff(date_format(max(s.order_date),'%Y%m'), date_format(min(s.order_date), '%Y%m')) as lifespan
from fact_sales s
left join dim_customers c
on c.customer_key = s.customer_key
group by c.customer_key)

select customer_segment,
count(customer_key) as total_customers
from (
select customer_key,
case 
when lifespan >= 12 and total_spending > 5000 then 'VIP'
when lifespan >= 12 and total_spending <= 5000 then 'Regular'
else 'New'
end as customer_segment
from customer_spending) as customer_behaviour
group by customer_segment
order by total_customers desc ;






