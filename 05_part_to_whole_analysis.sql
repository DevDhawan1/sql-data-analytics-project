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