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