--=====================
-- Advanced Analytics
--=====================


-------------------------------
-- change over time "trends"
-------------------------------

--Analyze sales performance over time "years"

select
	datetrunc(year,order_date) as order_year,
	sum(sales_amount) total_sales
from gold.fact_sales f
where order_date is not null
group by datetrunc(year,order_date)
order by 1;



----------------------------
--cumulative analysis
----------------------------

-- calculate the total sales per month and the running total of sales over time

select
	month,
	total_sales,
	sum(total_sales) over(order by month rows between unbounded preceding and current row) as running_total
from(
	select
		datetrunc(month,order_date) as month,
		sum(sales_amount) as total_sales
	from gold.fact_sales
	where order_date is not null
	group by datetrunc(month,order_date))t
order by 1;


--calculate the total sales per year and running total & the moving average price

select
	year,
	total_sales,
	sum(total_sales) over(order by year) as running_total,
	avg_price,
	avg(avg_price) over(order by year) as moving_average
from(
	select
		year(order_date) year,
		sum(sales_amount) total_sales,
		avg(price) avg_price
	from gold.fact_sales
	where order_date is not null
	group by year(order_date))t
order by year;


---------------------------
-- Performance analysis
---------------------------


/*analyze the yearly performance of products by comparing each product's sales to 
  both its average sales and the previous year's sales*/

with product_yearly as (
	select 
		year(order_date) "year",
		p.product_key,
		product_name,
		sum(sales_amount) as total_sales,
		avg(sales_amount) as avg_sales
	from gold.fact_sales f
	left join gold.dim_products p
	on f.product_key = p.product_key
	where order_date is not null
	group by year(order_date),p.product_key,product_name
	)

select
	year,
	product_key,
	product_name,
	total_sales,
	avg_sales,
	avg(total_sales) over(order by year) as avg_sales,
	total_sales - avg(total_sales) over(order by year) as diff_avg,
	case
		when total_sales - avg(total_sales) over(order by year) > 0 then 'Above Avg'
		when total_sales - avg(total_sales) over(order by year) < 0 then 'Below Avg'
		else 'Avg'
	end avg_status,
	lag(total_sales) over(order by year) py_sales,
	total_sales - lag(total_sales) over( order by year) diff_py,
	case
		when total_sales - lag(total_sales) over( order by year) > 0 then 'Increased'
		when total_sales - lag(total_sales) over( order by year) < 0 then 'Decreased'
		else 'No change'
	end py_status
from product_yearly;


----------------------------
-- part to whole analysis
----------------------------

--which categories contribute the most to overall sales?

with category_sales as (
	select
		category,
		sum(sales_amount) as total_sales
	from gold.fact_sales f
	left join gold.dim_products p
	on f.product_key = p.product_key
	group by category
	)

select
	category,
	total_sales,
	sum(total_sales) over() as overall_sales,
	concat(round((cast(total_sales as float) / sum(total_sales) over()) * 100,2),'%') as category_sales_percentage
from category_sales
order by 4 desc;


------------------------
-- data segmentation
------------------------

-- segment products into cost range and count how many products fall into each segment

select
	case
		when cost < 100 then 'Below 100'
		when cost < 500 then '100-500'
		when cost < 1000 then '500-1000'
		else 'Above 1000'
	end cost_segment,
	count(distinct product_key) as total_products
from gold.dim_products
group by 
		case
			when cost < 100 then 'Below 100'
			when cost < 500 then '100-500'
			when cost < 1000 then '500-1000'
			else 'Above 1000'
		end
order by 2 desc;


/*Group customers into 3 segments based on their spening behavior:
	-VIP: at least 12 months of history and spending more than 5,000.
	-Regular: at least 12 months of history but spending 5,000 or less.
	-New: lifespan less than 12 months 
 and find the total customers in each segment*/

 with customer_data as (
	 select
		c.customer_key,
		sum(sales_amount) total_spending,
		max(order_date) last_order_date,
		datediff(month,min(order_date),max(order_date)) lifespan
	 from gold.fact_sales f
	 left join gold.dim_customers c
	 on f.customer_key = c.customer_key
	 group by c.customer_key
	 )

select
	customer_segment,
	count(distinct customer_key) as total_customers
from (
		select
			customer_key,
			case
				when lifespan >= 12 and total_spending > 5000 then 'VIP'
				when lifespan >= 12 and total_spending <= 5000 then 'Regular'
				else 'New'
			end customer_segment,
			total_spending,
			lifespan,
			last_order_date
		from customer_data )t
group by customer_segment
order by 2 desc;
