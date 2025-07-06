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