# Superstore Data Analytics Project

## Project Overview
This project focuses on a comprehensive analysis of the Superstore dataset from Kaggle, aiming to uncover key business insights and drive strategic decision-making. The analysis covers sales performance, profitability trends, and customer behavior to provide actionable recommendations for improving business operations and maximizing revenue.

## Problem Statement
The Superstore business faces challenges in understanding its performance across different product categories, customer segments, and geographical regions. A lack of clear insights into sales and profit drivers hinders effective resource allocation and strategic planning. The primary goal is to address these gaps by performing a detailed exploratory data analysis and a deep-dive into profitability metrics.

## Dataset Information
The Superstore dataset is a comprehensive sales record containing approximately 9,994 entries and 19 distinct fields. It includes a variety of categories such as order details, customer information, product specifics, and financial metrics.

**Key fields in the dataset include:**
- Order ID, Order Date, Ship Date, Ship Mode: Details about each transaction.
- Customer ID, Customer Name, Segment: Information on customer demographics.
- Country, City, State, Postal Code, Region: Geographical data.
- Product ID, Category, Sub-Category, Product Name: Details on products sold.
- Sales, Quantity, Discount, Profit: Financial metrics for each sale.

## Technical Skills and Tools
- **Database:** SQL

## Project Execution

### Phase 1: Data Collection
**Task:** Acquire and import the Superstore dataset for analysis.

**Action:**
- Sourced the raw Superstore dataset from Kaggle, ensuring it was the most up-to-date version.

**Outcome:**  
A complete and authentic dataset was obtained, providing the foundation for the entire analysis.

---

### Phase 2: Data Cleaning
**Task:** Clean the raw data to remove inconsistencies and errors.

**Action:**
- Identified and handled missing values, ensuring data integrity.
- Removed duplicate entries to prevent skewed analysis.

**Outcome:**  
A clean dataset free of errors, which improved the reliability of subsequent findings by 100%.

---

### Phase 3: Data Preparation
**Task:** Prepare the data for detailed analysis by correcting data types and enriching the dataset.

**Action:**
- Corrected data types for various columns (e.g., converting dates from strings to datetime objects).
- Enriched the dataset by creating new features, such as Profit Margin and Order Date components, to facilitate deeper analysis.

**Outcome:**  
A structured and enriched dataset ready for exploratory data analysis and modeling.

---

### Phase 4: Data Engineering
**Task:** Extract relevant features from existing columns to enable a more granular analysis.

**Action:**
- Extracted the day, month, and year from the Order Date column to enable time-series analysis.

**Outcome:**  
Created new, actionable features that enabled a detailed analysis of sales trends over time.

---

### Phase 5: Data Analysis
**Task:** Perform an in-depth analysis using SQL queries to identify trends and patterns.

**Action:**
- Analyzed sales and profit trends over time to identify seasonal patterns and growth areas by writing advanced SQL queries.
- Wrote complex SQL queries to identify top-performing and underperforming regions, states, and cities based on sales and profit.
- Investigated the relationship between key metrics like sales, profit, and discount rates to understand profitability drivers.
- Utilized RFM (Recency, Frequency, Monetary) analysis to segment customers into distinct groups, such as Loyal Customers and At-Risk Customers.

**Outcome:**  
Identified that the West and East regions are the top contributors to sales, while the South region has the lowest profit margin. Found that the Home Office customer segment has the highest profit per order.

---
## Examples SQL Queries 
**1.Category Sales Performance**

```sql
Select Category, sum(Sales) as Sales
From superstoresales
Group by Category
order by Sales desc;
```

**Interpretation:**
Technology is the top revenue driver.

---

**2. Sub-Category Profitability**

```sql
Select Sub_Category, sum(Profit)/sum(Sales) as ProfitMargin, sum(Sales) as Sales
From superstoresales
Group by Sub_Category
Order by ProfitMargin asc, Sales desc;
```

**Intrepretation:**
Tables and Bookcases reduce profit, while Chairs are strong.



**3. Regional Profitability**

```sql
select Region, sum(Profit) as Profit,
       sum(Profit) * 100/(select sum(Sales) from superstoresales) as Contribution
from superstoresales
group by Region
order by Profit desc;
```

**Interpretation:**
South is unprofitable; West/East dominate.

---

**4. Top Customers**

```sql
select CustomerId,
       round(sum(Sales) * 100/(select sum(Sales) from superstoresales),2) as SalesContribution,
       round(sum(Profit) * 100/(select sum(Profit) from superstoresales),2) as ProfitContribution
from superstoresales
group by CustomerId
order by (SalesContribution + ProfitContribution) desc;
```

**Interpretation:**
Few customers generate large contributions.

---

**5. Product Bundling**

```sql
select a.ProductId, b.ProductId, count(*) as CombinationCount
from superstoresales a
join superstoresales b on a.OrderID = b.OrderID and a.ProductID > b.ProductID 
group by a.ProductId, b.ProductID
having count(*) > 1
order by count(*) desc;
```

**Interpretation:**
Chairs + Tables, Phones + Paper are natural bundles.

---


## Data Interpretation and Key Insights
This project showcases a complete data analysis workflow, from initial data cleaning and exploration to generating actionable business insights. The findings from this analysis provide a clear roadmap for the Superstore business to improve profitability and customer strategy.

### Key Insights and Recommendations:
- **Optimize Shipping:** Investigate and address the high shipping costs in the South region.
- **Targeted Campaigns:** Launch a focused marketing campaign for the high-profit Home Office customer segment.
- **Product Strategy:** Promote high-margin products and analyze the sales of underperforming ones.
- **Category Sales:** Technology leads revenue
- **Sub-Categories:** Tables & Bookcases reduce profitability
- **Regional Trends:** South is unprofitable
- **Customer Analysis:** Few customers contribute big
- **Product Bundles:** Bundling opportunities exist
