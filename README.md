# End-to-End Sales Analytics Project (SQL Data Warehouse & Power BI)

This project is the **second phase** of my end-to-end sales data journey.

- In the **first phase**, I designed and implemented a **Sales Data Warehouse in SQL Server** (bronze → silver → gold layers).
- In this **second phase**, I use the warehouse as a source for **advanced SQL analytics and Power BI reporting**.

➡️ Data Warehouse Project (Phase 1): [[link to your DWH GitHub repo](https://github.com/MostafaHafez9/SQL-data-warehouse-project)]

---

## 🔧 Tech Stack

- **Database:** SQL Server  
- **Query Language:** T-SQL  
- **Data Modeling:** Fact & Dimension Tables (Star Schema)  
- **BI Tool:** Power BI (Power Query, Data Modeling, DAX)  

---

## 🧱 Project Architecture (Quick Overview)

**Phase 1 – Data Warehouse (SQL Server)**  
- Raw data loaded into **Bronze** (staging) tables.  
- Cleaned and standardized in **Silver** tables.  
- Modeled into a **star schema** in the **Gold** layer:
  - `gold.fact_sales`
  - `gold.dim_customers`
  - `gold.dim_products`

**Phase 2 – Analytics & Reporting (This Repo)**  
- Advanced SQL analysis (EDA + analytics).  
- Creation of reporting views:
  - `gold.customers_report`
  - `gold.products_report`
- Power BI report connected to the Gold layer and views.

---

## 📊 SQL Analysis

All SQL scripts are included in the `sql` folder:

- **01_EDA.sql**
  - Schema exploration (tables, columns).
  - Date ranges, customer age distribution.
  - Product categories and basic KPIs:
    - Total Sales, Total Orders, Total Customers, Total Products, Total Quantity, Average Price.

- **02_Advanced_Analytics.sql**
  - Sales trends by year and month.
  - Running totals and moving averages.
  - Product performance over time (above/below average, YoY change).
  - Part-to-whole analysis (category share of total sales).
  - Customer segmentation:
    - VIP / Regular / New (based on spending & lifespan).
  - Product segmentation:
    - High Performers / Mid-Range / Low Performers (based on revenue).

- **03_Reports_Customers_Products.sql**
  - `gold.customers_report` view:
    - Customer profile, segment, age group, recency, total orders, total sales, average order value, average monthly spend.
  - `gold.products_report` view:
    - Product segment, revenue, orders, customers, recency, average order revenue, average monthly revenue.

---

## 📈 Power BI Report

The Power BI file (`Sales_Analytics_Report.pbix`) contains a 4-page report:

1. **Sales Overview**
   - KPIs: Total Sales, Total Orders, Total Customers, Total Quantity, Average Order Value.
   - Sales over time (year).
   - Sales by Category.
   - Sales by Country (map or column chart).
   - Slicers: Year, Country, Category.

2. **Customer Analysis**
   - KPIs: Total Customers, VIP Customers, Regular Customers, New Customers, Average Monthly Spend, Average Order Value.
   - Customers by Segment & Sales by Segment.
   - Customers by Age Group.
   - Sales by Country (with tooltip showing total customers).
   - Top 10 Customers by Total Sales.
   - Cohort-style view to understand customer growth and retention over time.
   - Slicers: Customer Segment, Country, Age Group, Year.

3. **Product Analysis**
   - KPIs: Total Products, High Performers, Mid-Range, Low Performers, Average Monthly Revenue, Average Order Revenue.
   - Total Sales by Product Segment.
   - Total Quantity by Category.
   - Total Products by Product Segment.
   - Sales by Subcategory or Product Line.
   - Top 10 Products by Total Sales.
   - Slicers: Category, Product Segment, Subcategory, Year.
   - Custom tooltips for:
     - Products by Category
     - Orders by Top Subcategories
     - Top 5 Products by Revenue.

4. **Key Insights & Recommendations**
   - Summary of main findings across:
     - Sales performance
     - Customer segments and behavior
     - Product segments
   - Recommendations on:
     - Focusing on high-performing products and key markets.
     - Improving low-performing segments.
     - Activating and retaining New and Regular customers.

---

## 🖼 Dashboard Screenshots

The `images` folder includes:

- `Sales_Overview.png`
- `Customer_Analysis.png`
- `Product_Analysis.png`
- `Key_Insights_Recommendations.png`

---

## 🔍 Key Insights (High Level)

- A small group of **high-performing products** and **key markets** drives a large share of total revenue.
- **VIP customers** generate a big portion of revenue, but there is clear potential to grow:
  - **Regular** and **New** customers through better targeting.
- Several **underperforming product segments** represent opportunities for:
  - Focused promotions
  - Cross-selling and upselling strategies.
- Customer-level metrics like **recency**, **average order value**, and **average monthly spend** help prioritize retention efforts.

---

## 📂 Repository Structure

```text
.
├── sql
│   ├── 01_EDA.sql
│   ├── 02_Advanced_Analytics.sql
│   └── 03_Reports_Customers_Products.sql
├── pbix
│   └── Sales_Analytics_Report.pbix
├── images
│   ├── Sales_Overview.png
│   ├── Customer_Analysis.png
│   ├── Product_Analysis.png
│   └── Key_Insights_Recommendations.png
└── README.md

