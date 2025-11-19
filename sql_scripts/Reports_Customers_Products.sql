--=============
-- Reports
--=============


/*
---------------------
   Customer Report
---------------------
	Purpose:
		- This report consolidates key customer metrics and behvaiors.
	Highlights:
		1- Gather essential fields such as names, ages, and transaction details.
		2- Segments customer into categories (VIP / Regular / New) and group age.
		3- Aggregate customer-level metrics:
			- Total order
			- Total sales
			- Total quantity
			- Total products
			- lifespan (in month)
		4- Calculate valuable KPIs:
			- Recency (month since last order)
			- Average order value
			- Average monthly spend
*/


create view gold.customers_report as

	with base_query as (
		select
			c.customer_key,
			concat(c.first_name,' ',c.last_name) as customer_name,
			c.birth_date,
			datediff(year,c.birth_date,getdate()) as age,
			c.country,
			c.gender,
			c.marital_status,
			f.order_date,
			f.order_number,
			f.product_key,
			f.sales_amount,
			f.quantity,
			f.price,
			f.shipping_date,
			f.due_date
		from gold.fact_sales f
		left join gold.dim_customers c
		on f.customer_key = c.customer_key
		)

	, customer_aggregation as (
		select
			customer_key,
			customer_name,
			age,
			gender,
			birth_date,
			marital_status,
			country,
			order_date,
			count(order_number) as total_orders,
			sum(sales_amount) as total_sales,
			count(product_key) as total_products,
			sum(quantity) as total_quantity,
			datediff(month,min(order_date),max(order_date)) as lifespan,
			max(order_date) as last_order_date
		from base_query
		group by customer_key,
			customer_name,
			age,
			gender,
			birth_date,
			marital_status,
			country,
			order_date
		)

	select
		customer_key,
		customer_name,
		country,
		age,
		marital_status,
		gender,
		case
			when lifespan >= 12 and total_sales > 5000 then 'VIP'
			when lifespan >= 12 and total_sales <= 5000 then 'Regular'
			else 'New'
		end customer_segment,
		case
			when age < 20 then 'Under 20'
			when age between 20 and 29 then '20-29'
			when age between 30 and 39 then '30-39'
			when age between 40 and 49 then '40-49'
			else '50 and above'
		end age_group,
		total_orders,
		total_sales,
		total_quantity,
		total_products,
		last_order_date,
		datediff(month,last_order_date,getdate()) as recency,
		case
			when total_orders = 0 then 0
			else total_sales / total_orders
		end avg_order_value,
		case
			when lifespan = 0 then total_sales
			else total_sales / lifespan
		end avg_monthly_spend
	from customer_aggregation;

--check the customer report view

select * from gold.customers_report;





/* 
------------------------
	Product Report
------------------------
	Purpose:
		- This report consolidates key product metrics
	Highlights:
		1- Gather essential fields such as product name, category, subcategory, and cost.
		2- Segments products by revenue to identify high-performes, mid_range, or low-performers.
		3- Aggregates product-level metrics:
			- total orders
			- total sales
			- total quantity sold
			- total customers (unique)
			- lifespan (in month)
		4- Calculate valuable KPIs:
			- recency (month since last sale)
			- average order revenue (AOR)
			- average monthly revenue
*/

create view gold.products_report as
	with base_query as (
		select
			p.product_key,
			p.product_name,
			p.category,
			p.subcategory,
			p.cost,
			p.maintenance,
			f.customer_key,
			f.sales_amount,
			f.order_date,
			f.order_number,
			f.quantity,
			f.price
		from gold.fact_sales f
		left join gold.dim_products p
		on f.product_key = p.product_key
		)

	, product_aggregation as (
		select
			product_key,
			product_name,
			category,
			subcategory,
			maintenance,
			cost,
			sum(sales_amount) as total_sales,
			count(order_number) as total_orders,
			count(distinct customer_key) as total_customers,
			sum(quantity) as total_quantity,
			max(order_date) as last_sale_date,
			datediff(month,min(order_date),max(order_date)) as lifespan
		from base_query
		group by 
			product_key,
			product_name,
			category,
			subcategory,
			maintenance,
			cost
		)

	select
		product_key,
		product_name,
		category,
		subcategory,
		maintenance,
		case
			when total_sales >= 50000 then 'High Performer'
			when total_sales >= 10000 then 'Mid-Range'
			else 'Low Performer'
		end product_segment,
		cost,
		total_sales,
		total_quantity,
		total_orders,
		total_customers,
		datediff(month,last_sale_date,getdate()) recency,
		case
			when total_orders = 0 then 0
			else total_sales / total_orders
		end avg_order_revenue,
		case
			when lifespan = 0 then total_sales
			else total_sales / lifespan
		end avg_monthly_revenue
	from product_aggregation;


--check the product report view

select * from gold.products_report;
