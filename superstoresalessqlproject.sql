-- 1 A

-- make the group of category and month by salesContribution
-- make a pivot of group = category columns = seperate month(Jan,Feb) values = SalesContribution
-- make a pivot of group = category columns = slab of inc and decrease between month (Jan_Feb, Feb_Mar) values = SalesContribution
with CategorySales as (
select Category, month(str_to_date(OrderDate,"%m/%d/%Y")) as month,  sum(Sales) as CategorySales
From superstoresales
Group by Category, month
), month as (
Select Category,
sum(case when month = 1 then CategorySales end) as Jan,
sum(case when month = 2 then CategorySales end) as Feb,
sum(case when month = 3 then CategorySales end) as Mar,
sum(case when month = 4 then CategorySales end) as Apr,
sum(case when month = 5 then CategorySales end) as May,
sum(case when month = 6 then CategorySales end) as Jun,
sum(case when month = 7 then CategorySales end) as Jul,
sum(case when month = 8 then CategorySales end) as Aug,
sum(case when month = 9 then CategorySales end) as Sep,
sum(case when month = 10 then CategorySales end) as Oct,
sum(case when month = 11 then CategorySales end) as Nov,
sum(case when month = 12 then CategorySales end) as Decrease
From CategorySales
Group by Category
)
Select Category, 
coalesce(case when Jan - Feb < 0 then "Increase" when Jan - Feb > 0 then "Decrease" else "No Change" end,0) as Jan_Feb,
coalesce(case when Feb - Mar < 0 then "Increase" when Feb - Mar > 0 then "Decrease" else "No Change" end,0) as Feb_Mar,
coalesce(case when Mar - Apr < 0 then "Increase" when Mar - Apr > 0 then "Decrease" else "No Change" end,0) as Mar_Apr,
coalesce(case when Apr - May < 0 then "Increase" when Apr - May > 0 then "Decrease" else "No Change" end,0) as Apr_May,
coalesce(case when May - Jun < 0 then "Increase" when May - Jun > 0 then "Decrease" else "No Change" end,0) as May_Jun,
coalesce(case when Jun - Jul < 0 then "Increase" when Jun - Jul > 0 then "Decrease" else "No Change" end,0) as Jun_Jul,
coalesce(case when Jul - Aug < 0 then "Increase" when Jul - Aug > 0 then "Decrease" else "No Change" end,0) as Jul_Aug,
coalesce(case when Aug - Sep < 0 then "Increase" when Aug - Sep > 0 then "Decrease" else "No Change" end,0) as Aug_Sep,
coalesce(case when Sep - Oct < 0 then "Increase" when Sep - Oct > 0 then "Decrease" else "No Change" end,0) as Sep_Oct,
coalesce(case when Oct - Nov < 0 then "Increase" when Oct - Nov > 0 then "Decrease" else "No Change" end,0) as Oct_Nov,
coalesce(case when Nov - Decrease < 0 then "Increase" when Nov - Decrease > 0 then "Decrease" else "No Change" end,0) as Nov_December,
coalesce(case when Decrease - Jan < 0 then "Increase" when Decrease - Jan > 0 then "Decrease" else "No Change" end,0) as December_Jan
From month
Group by Category;

-- 1 A

Select Category, sum(Sales) as Sales
From superstoresales
Group by Category
order by Sales desc;

-- 1 B

-- find the sales contribution and profit margin of sub categories
-- Then order them by sales contribution asc and profit margin desc
Select Sub_Category, sum(profit/Sales) as profitmargin, Sum(Sales/Sales)  as Sales
From superstoresales
Group by Sub_Category
Order by profitmargin asc, Sales desc;

-- 1 C

-- make group of region and categories and month and find out total sales by sum(Sales)*100/(select sum(sales) * 100)
-- make pivot of group = region, category columns = seperate month (Jan, Feb), values = sum(Sales)*100/(select sum(sales) * 100)
-- make pivot of group = region, category columns = monthdiff in Increase/Decrease (Jan_Feb, Feb_Mar)
With grouping1 as (
Select Region,Category, month(str_to_date(OrderDate, "%d/%m/%Y")) as salemonth,sum(Sales) as Sales
From superstoresales
Group by Region, Category, salemonth
),pivot1 as (
Select Region, Category,
sum(case when salemonth = 1 then Sales end) as Jan,
sum(case when salemonth = 2 then Sales end) as Feb,
sum(case when salemonth = 3 then Sales end) as Mar,
sum(case when salemonth = 4 then Sales end) as Apr,
sum(case when salemonth = 5 then Sales end) as May,
sum(case when salemonth = 6 then Sales end) as Jun,
sum(case when salemonth = 7 then Sales end) as Jul,
sum(case when salemonth = 8 then Sales end) as Aug,
sum(case when salemonth = 9 then Sales end) as Sep,
sum(case when salemonth = 10 then Sales end) as Oct,
sum(case when salemonth = 11 then Sales end) as Nov,
sum(case when salemonth = 12 then Sales end) as December
From grouping1
Group by Region, Category
)
Select Region, Category,
coalesce((Case when Jan - Feb < 0 then "Increase" when Jan - Feb > 0 then "Decrease" end),0) as Jan_Feb,
coalesce((Case when Feb - Mar < 0 then "Increase" when Feb - Mar > 0 then "Decrease" end),0) as Feb_Mar,
coalesce((Case when Mar - Apr < 0 then "Increase" when Mar - Apr > 0 then "Decrease" end),0) as Mar_Apr,
coalesce((Case when Apr - May < 0 then "Increase" when Apr - May > 0 then "Decrease" end),0) as Apr_May,
coalesce((Case when May - Jun < 0 then "Increase" when May - Jun > 0 then "Decrease" end),0) as May_Jun,
coalesce((Case when Jun - Jul < 0 then "Increase" when Jun - Jul > 0 then "Decrease" end),0) as Jun_Jul,
coalesce((Case when Jul - Aug < 0 then "Increase" when Jul - Aug > 0 then "Decrease" end),0) as Jul_Aug,
coalesce((Case when Aug - Sep < 0 then "Increase" when Aug - Sep > 0 then "Decrease" end),0) as Aug_Sep,
coalesce((Case when Sep - Oct < 0 then "Increase" when Sep - Oct > 0 then "Decrease" end),0) as Sep_Oct,
coalesce((Case when Oct - Nov < 0 then "Increase" when Oct - Nov > 0 then "Decrease" end),0) as Oct_Nov,
coalesce((Case when Nov - December < 0 then "Increase" when Nov - December > 0 then "Decrease" end),0) as Nov_December,
coalesce((Case when December - Jan < 0 then "Increase" when December - Jan > 0 then "Decrease" end),0) as December_Jan
from pivot1
group by Region, Category
order by Region, Category;

-- 1 D

-- find price by sales - profit and find the avg(Discount) and sum(ProfitMargin) by the Segment
-- Those segment should be prioritized which has less Discount and more profitmargin and more price and more SalesContribution
select Segment, sum(Sales - Profit) as Price, sum(Discount) as Discount, sum(Profit/Sales) as ProfitMargin, Sum(Sales) as Sales
from superstoresales
group by Segment
order by ProfitMargin desc, Sales desc,  Discount asc, Price desc;

-- 1 E


with disinfo as (
Select Category,Discount,sum(Sales/(1 - Discount)) as ActualSales, sum(Sales) as DiscountedSales, sum((Sales/(1 - Discount)) - (Sales-Profit)) as ActualProfit, sum(Profit) as DiscountedProfit
from superstoresales
where discount > 0
group by Category,Discount
)
select Category,Discount,
case when ActualSales > DiscountedSales then "Decrease"  when ActualSales < DiscountedSales then "Increase" else "Nochange" end as SalesChange,
case when ActualProfit > DiscountedProfit then "Decrease"  when ActualProfit < DiscountedProfit then "Increase" else "Nochange" end as ProfitChange
from disinfo
GROUP BY Category, Discount;
-- 2 A
-- Not found 


-- 2 B

-- Most profitable Region
-- Calculate contribution

select Region,sum(Profit) as Profit,sum(Profit) * 100/(select sum(sales) from superstoresales) as contribution 
from superstoresales
group by Region
order by Profit desc;

-- Most profitable City

select City,sum(Profit) as Profit,sum(Profit) * 100/(select sum(sales) from superstoresales) as contribution
from superstoresales
group by City
order by Profit desc;

-- Least profitable Region

select  Region,sum(Profit) as Profit, (sum(Profit) * 100/(select sum(sales) from superstoresales)) as contribution
from superstoresales
group by Region
order by Profit asc;

-- Least profitable City 

select City,sum(Profit) as Profit,(sum(Profit) * 100/(select sum(sales) from superstoresales)) as contribution
from superstoresales
group by City
order by Profit asc;
-- 2 C

-- make group of shipmode and according to that find Profit, Sales and ProfitMargin
-- Then order the whole query by profit margin to know which has the lowest margin due to high cost
   select ShipMode, sum(Profit) as Profit, sum(Sales) as Sales, (sum(Profit)/sum(Sales)) * 100 as ProfitMargin
    from superstoresales
    group by ShipMode
    order by ProfitMargin asc;

-- 2 D

-- make group of Region Category Segment and their values will be avgprofitperorder
-- AvgProfitPerOrder = sum(Profit)/count(distinctOrderID)
SELECT Region, Category, Segment,
       SUM(Profit) / COUNT(DISTINCT OrderID) AS AvgProfitPerOrder
FROM superstoresales
GROUP BY Region, Category, Segment
ORDER BY Region, Category, Segment;
-- 2 E

-- make group of Segment and their LifeTimeValue according to each customer by formula Sales/ distinct CustomerID
-- order them by highest lifetime value to find out Segment with hightest lifetime value
select Segment, sum(Sales)/count(distinct CustomerId) as LifetimeValue
from superstoresales
group by Segment
order by LifetimeValue desc;



-- 3 A Who are the top customers by revenue and by profit?

-- make group of customers and find out their total sales and profit contribution
-- then order by SalesContribution + ProfitContribution desc to find out the top customers
select 
	CustomerId, 
	round(sum(Sales) * 100/(select sum(Sales) from superstoresales),2) as SalesContribution,
    round(sum(Profit) * 100/(select sum(Profit) from superstoresales),2) as ProfitContribution
from superstoresales
group by CustomerId
order by 
	round(sum(Sales) * 100/(select sum(Sales) from superstoresales),2) +
    round(sum(Profit) * 100/(select sum(Profit) from superstoresales),2) asc;
    
-- 2 B How many repeat customers does the store have, and what is their contribution to total revenue?


with cteSalesContribution as (
select 
	CustomerId,
	count(distinct OrderId) as distinctorders, 
	round(sum(Sales) * 100/(select sum(Sales) from superstoresales),2) as SalesContribution
from superstoresales
group by CustomerId
having count(distinct OrderId) > 1
)
select count(CustomerId) as repeat_cust,round(sum(SalesContribution),2) as total_contribution
from cteSalesContribution;
-- 2 C  Which customers only buy during discounts — and do they generate profit?

-- find out the avg discount and total profit of each customer
-- filter discount greater than 0 to find customers who only purchase during discount
-- filter profit greater than 0 to find only profitable customers
select
    CustomerID,
    avg(Discount) as Discount,
    sum(Profit) as Profit
from
    superstoresales
group by
    CustomerID
having
    sum(Profit) > 0 and avg(Discount) > 0
ORDER BY
    `Profit` desc;

-- Which geographic areas have high customer density but low sales?

-- first i group the country and state and find the state sales
-- then i find out the country sales and divide by state sales to find out population density
-- then i add Sales contribution in the whole query to find out sales
-- then i order by CustomerDensity desc and SalesContribution asc
select
	Country,
	State,
	count(distinct CustomerID)/(select count(distinct CustomerID) from superstoresales group by Country) as PopulationDensity,
	sum(Sales)/(select sum(sales) from superstoresales) as SalesContribution
from
	superstoresales
group by
	Country,
	State
order by
	PopulationDensity desc,
	SalesContribution asc;


-- How do different customer segments respond to pricing and discount strategy

-- made a pivot of group = discount columns = different segment values = count(distinct OrderId)
-- I have filtered the discount > 0 becouse it is not a discounting strategy


select
	Discount,
	count(distinct case when Segment = 'Corporate' then OrderID end) as Corporate,
	count(distinct case when Segment = 'Consumer' then OrderID end) as Consumer,
	count(distinct case when Segment = 'Home Office' then OrderID end) as Home_Office
from
	superstoresales
where
	Discount > 0
group by
	Discount
order by
	Discount;

-- 4. Product & Inventory Insights

-- 4 A Which products should be bundled together based on frequent co-purchases?

select a.ProductId, b.ProductId, count(*) as combinationcount
from superstoresales a
join superstoresales b on a.OrderID = b.OrderID and a.ProductID > b.ProductID 
group by a.ProductId, b.ProductID
having count(*) > 1
order by count(*) desc;

-- 4 B What’s the product return risk based on past profit margins and sales trends?

-- find out product with more quantity sold and more sales but less profit and more discount

select 
	ProductId,
    round(avg(Discount),2) as Discount,
    sum(Quantity) as Quantity,
    round(sum(Sales) * 100/(select sum(Sales) from superstoresales),2) as SalesContribution,
    round(sum(Profit) * 100/(select sum(Profit) from superstoresales),2) as ProfitContribution
from superstoresales
group by ProductID
having avg(Discount) > 0
order by
	round(avg(Discount),2) +
	sum(Quantity) +
    round(sum(Sales) * 100/(select sum(Sales) from superstoresales),2) desc, 
    round(sum(Profit) * 100/(select sum(Profit) from superstoresales),2) asc;

-- 4 C Which products are slow movers and taking up inventory space?(basic analysis)

-- productID sum(Quantity) 
-- order by sum(Quantity) desc
-- I have done basic analysis in which i have made group of ProductID by the sum(Quantity)
-- Then I have ordered the quantity asc to find the slow movers

select
    ProductID, sum(Quantity) as Quantity
from
    superstoresales
group by
    ProductID
order by
    Quantity asc;

-- 4 D Which sub-categories are growing in popularity, and which are declining?(last three month)

-- growing in popularity = order by  count(distinct CustomerID) desc
-- less in popularity  = less count(distinct CustomerID)
-- Sub_Category October November December
-- Sub_Category month(str_to_date(OrderDate,'%m/%d/%Y')) as month    count(distinct CustomerID) as custcount   filter  = 10 11 12

with filteredmonth as (
select
    Sub_Category, 
    month(str_to_date(OrderDate,'%m/%d/%Y')) as salesmonth,
     count(distinct CustomerID) as custcount
from
    superstoresales
where
    month(str_to_date(OrderDate,'%m/%d/%Y')) in (10,11,12)
group by
    Sub_Category,
    month(str_to_date(OrderDate,'%m/%d/%Y')) 
  )
select
    Sub_Category,
    sum(case when salesmonth = 10 then custcount end) as October,
    sum(case when salesmonth = 11 then custcount end) as November,
    sum(case when salesmonth = 12 then custcount end) as December
from
    filteredmonth
group by
    Sub_Category;


	
-- 4 E What’s the SKU performance ranking by sales and profit contribution?       

-- ProductID sum(Sales) sum(Profit) skurank
-- ntile(10)
-- ProductID sum(Sales) sum(Profit)
-- order by sales + profit desc

-- find out the sales and profit and order by sales and profit desc 
-- then use ntile to find out the sku rank


with saleprofit as (
select
	ProductID,
    sum(Sales) as Sales,
    sum(Profit) as Profit
from
	superstoresales
group by
		ProductID
)
select
	*,
    ntile(100) over (order by Sales + Profit desc) as skurank
from
	saleprofit;
   
-- 4 
-- 4 A Does the shipping mode affect customer profitability?

-- ShipMode sum(Profit)/sum(Sales) * 100
-- order by ProfitMargin desc

-- we took the shipmode and its respective profitmargin
-- we order them by profitmargin in a descending order
select
	ShipMode,
    sum(Profit)/sum(Sales) * 100 as ProfitMargin
from
	superstoresales
group by
	ShipMode
order by 2 desc;

-- 4 B Which states have the longest delivery times, and is it affecting sales or customer satisfaction?

-- State deliverytime sum(Sales)
--		desc
-- State datediff(str_to_date(ShipDate,"%d/%m/%Y"),str_to_date(OrderDate,"%d/%m/%Y")), sum(Sales)

-- first i took the state their delivertime and salescontribution
-- then i have ordered them by desc deliverytime
-- then i make pivot of group = delvtime columns = 'State' values = 'SalesContribution'

with timecontribution as (
select
	State,
	datediff(str_to_date(ShipDate,"%d/%m/%Y"),str_to_date(OrderDate,"%d/%m/%Y")) as delvtime,
    sum(Sales) * 100/(select sum(sales) from superstoresales) as SalesContribution
from
	superstoresales
group by
	State,
    datediff(str_to_date(ShipDate,"%d/%m/%Y"),str_to_date(OrderDate,"%d/%m/%Y"))
order by
	2 desc ,3 desc
)
select
	delvtime,
	sum(case when State = 'California' then SalesContribution end) as California,
	sum(case when State = 'Florida' then SalesContribution end) as Florida,
	sum(case when State = 'Kentucky' then SalesContribution end) as Kentucky,
	sum(case when State = 'New Mexico' then SalesContribution end) as New_Mexico,
	sum(case when State = 'Texas' then SalesContribution end) as Texas,
	sum(case when State = 'Michigan' then SalesContribution end) as Michigan,
	sum(case when State = 'Arizona' then SalesContribution end) as Arizona,
	sum(case when State = 'Indiana' then SalesContribution end) as Indiana,
	sum(case when State = 'Iowa' then SalesContribution end) as Iowa,
	sum(case when State = 'North Carolina' then SalesContribution end) as North_Carolina
from
	timecontribution
group by
	delvtime
order by
	1 desc;


-- 4 C Is there a correlation between shipping time and profit margins?

-- 4 D How do shipping costs affect profitability across different order sizes?


-- Quantity ShipMode1 ShipMod2 ...
-- Quantity sum(Profit)/sum(Sales) * 100
-- ShipMode OrderID avg(Quantity)

select ShipMode, sum(Profit)
from
	superstoresales
group by
	ShipMode;
with shipordersize as (
select
	ShipMode,
    OrderID,
    avg(Quantity) as OrderSize,
    sum(Profit)/sum(Sales) * 100 as ProfitMargin
from
	superstoresales
group by
	ShipMode,
    OrderID
)
select
	OrderSize,
	sum(case when ShipMode = 'Same Day' then ProfitMargin end) as Same_Day,
	sum(case when ShipMode = 'First Class' then ProfitMargin end) as First_Class,
	sum(case when ShipMode = 'Second Class' then ProfitMargin end) as Second_Class,
	sum(case when ShipMode = 'Standard Class' then ProfitMargin end) as Standard_Class
from
	shipordersize
group by
	OrderSize
order by
	1 desc;
    

-- 4 E Which shipping mode is most cost-effective for high-value products?


-- ProductID SHipMode1 ShipMode2 ShipMode3 ShipMode4
-- ProductID ProfitMargin
-- ProductID CostPrice
--				desc
-- ProductID (Sales/Quantity/1 - Disc) - Profit

-- find high value products by costprice order it by costprice desc
-- then make pivot of top10 products as group column = shipMode values = profitmargin of products


with highvalueproducts as (
select
	ProductID,ShipMode,
    ((sum(Sales))/(1 - sum(Discount))) - sum(Profit) as CostPrice,
    sum(Profit)/sum(Sales) * 100 as ProfitMargin
from
	superstoresales
group by
	ProductID,
    ShipMode
order by 2 desc
limit 10
)
select
	ProductID,
    sum(case when ShipMode = 'Same Day' then ProfitMargin end) as Same_Day,
	sum(case when ShipMode = 'First Class' then ProfitMargin end) as First_Class,
	sum(case when ShipMode = 'Second Class' then ProfitMargin end) as Second_Class,
	sum(case when ShipMode = 'Standard Class' then ProfitMargin end) as Standard_Class
from
	highvalueproducts
group by
	ProductID;




-- 5 
-- 5 A Which regions have high profit per customer and could be targeted for expansion?

-- Region Profit/PerCustomer
-- 			desc

-- for each region find their profitpercustomer
-- then order them by ProfitPerCustomer desc

select
	Region,
    sum(Profit)/count(distinct CustomerID) as ProfitPerCustomer
from
	superstoresales
group by
	Region
order by 2 desc;


-- 5 B Are there under-served states where sales are low despite large populations?

-- State count(distinct CustomerID) sum(Quantity)
-- 			desc						asc

-- find out state with their total population and totalquantityserved
-- order them by population desc and totalquantity asc
select
	State,
    count(distinct CustomerID) as Population,
    sum(Quantity) as Quantity
from
	superstoresales
group by
	State
order by
	2 desc , 3 asc;


-- 5 C Which product categories have strong growth potential in specific regions?

-- Region Category sum(Quantity) rnk = 1 and 2
-- Region Category sum(Quantity)

-- for each region find the sum of quantity of each product
-- rank category for each region and filter between 1 and 2
with categoryquantity as (
select
	Region,
    Category,
    sum(Quantity) as Quantity
from
	superstoresales
group by
	Region,
    Category
), regioncategoryrank as (
select
	*,
    rank() over (partition by Region order by Quantity asc) as rnk
from
	categoryquantity
)
select
	Region,
    Category,
    Quantity
from
	regioncategoryrank
where rnk between 1 and 2;

-- 5 D What would be the impact of reducing discounts on revenue and profit?

-- calculated profit and sales before and after discount and joined them by using union
-- then created pivot of group = profit,loss columns = beforediscount,afterdiscount values = all calculations
-- then to check change beforediscountcol < afterdiscountcol to get increase or decrease using case

with impact as (
select
	'After' as Category,'Profit' as SubCategory,avg(Profit) as Amount
from
	superstoresales
union
select
	'After' as Category,'Sales' as SubCategory,avg(Sales) as Amount
from
	superstoresales
union    
select
	'Before' as Category,'Profit' as SubCategory,avg(Profit)/1 - avg(Discount) as Amount
from
	superstoresales
union
select
	'Before' as Category,'Sales' as SubCategory,avg(Sales)/1 - avg(Discount) as Amount
from
	superstoresales
), impactpivot as (
select
	SubCategory,
    sum(case when Category = 'Before' then Amount end) as Beforecol,
    sum(case when Category = 'After' then Amount end) as Aftercol
from
	impact
group by
	SubCategory
)
select 
	*,
	case
		when Aftercol > Beforecol then 'Increase'
        else 'Decrease'
	end as ChangeProfitSales
from
	impactpivot;


-- 5 E Which products should be discontinued due to consistent losses?

-- Products count(ordermonth) as streak

-- Products month Profit lagmonthdifference leadmonthdifference
-- Condtition - Profit < 0
-- Condition - month - lagmonth = 1 and leadmonth - month = 1

-- first find out the productid date and profit and profit < 0
-- then find out lag and lead difference of dates 
-- if lagdifference  = 1 or leaddifference  = 1 then consecutive
-- then make group of ProductID and count month as Negative Streak and sumofsales to find totalloss


with grpmonth as (
select
	ProductId,
    month(str_to_date(OrderDate,'%m/%d/%Y')) as ordermonth,
    sum(Profit) as Profit
from
	superstoresales
group by
	ProductID,
    month(str_to_date(OrderDate,'%m/%d/%Y'))
having 
	sum(Profit) < 0
),laglead as (
select
	*,
    ordermonth - lag(ordermonth) over (partition by ProductID) as lagdifference,
    lead(ordermonth) over (partition by ProductID) - ordermonth as leaddifference      
from
	grpmonth
)
select
	ProductID, count(ordermonth) as NegativeStreak, sum(Profit) as Loss
from
	laglead
where 
	lagdifference = 1 or
	leaddifference = 1
group by
	ProductID
order by
	2 desc;