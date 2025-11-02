# Retail Store Exploratory Data Analysis

## Executive Summary
Due to the recent growth of competition in the market, RetailGiant wants to do an analysis to find out what works best
for them.

---

## Business Problem Outline
Due to the recent growth of competition in the market, RetailGiant wants to do an analysis on all of their sales data since 
their inception in 2015 to find out what works best for them. They want to become more efficient in order to keep a leg up
on the rising competition. They would like to understand which products, regions, categories and customer segments they should
target or avoid.

---

## Data Structure
![Image of the ERD for the data](/Images/ERD.png)

---

## Methodology
I received the data as an Excel Workbook where all of the tables are in their own tab, and I converted each table to its
own UTF8 CSV file in order to ingest it into the PostgresQL database. The data was manipulated with complex queries, and
the query results were made into views. The views were used to create the relevant data visualizations in Excel to
support my findings.

---

## Results and Business Recommendations
# Customer Segment
We need to re-evaluate our sales to our Corporate customer segment. It is the only segment to have a decrease in profit at all (this year - 2018), and the loss occured even with a 16% increase in Total Sales. The other two customer segments are both in the green; however, the Home Office segment had significant positive increase both last year (2017) and this year (2018). We should focus on maintaining our positive growth in the Home Office segment, and look into areas we can focus on to have greater growth in the Consumer segment next year.

![Image of the YoY Customer Segment Chart](/Images/YoY_Segment_Chart.png)

# Region
Futher analysis needs to be done here. The South and Central regions saw significant decrease in profits (with the Central region also seeing a slight decrease in sales). The growth patteern in the South region is similar to the growth pattern of the Corporate customer segment, so it should be investigateed further if the removal of the Corporate customer segment (or even just a particular product that is performing poorly when purchased by Corporate customers) is removed. On the other hand, the East and West regions both saw increases in sales and profit. We need to look deeper into what is leading this growth.

![Image of the YoY Region Chart](/Images/YoY_Region_Chart.png)

# Product Category
The Furniture needs to be investigated in more detail. The first and second and fourth year (this year) have large losses in YoY profit, but the third year has the biggest percentage of YoY growth among any category and year - 130%. These cause behind these extreme changes needs to be found before a decision can be made. The other categories performed just fine the past 2 years.

![Image of the YoY Region Chart](/Images/YoY_Category_Chart.png)

# Products
I found the Top 10 and Botton 10 products overall by both sales and profit. You can see in the Bottom 10 by Profit Chart [here](/Images/Bottom10_Products_Profit.png) that the majority of these products each year are in the Furniture category. Most of them are Tables. At the same time, none of the [bottom 10 products by sales](/Images/Bottom10_Products_Sales.png) have ever been a Furniture Product (it's mostly office supplies). Most of the top 10 products by [sales](/Images/Top10_Products_Sales.png) AND by [profit](/Images/Top10_Products_Profit.png) are in the Technology category. These are printers, copiers, and communication devices (phones and headsets). However, the interesting thing is that there are some Furniture products that are in the top 10 sales and profit, so I think there's something else that might be causing the massive profit loss in the Furniture category. We should narrow down the problem instead of avoiding the Furniture category altogether, and I recommend looking at the customer segment, the discount, and the quanities of Furniture orders.

---

## Next Steps
* Update the top/bottom 10 product tables to see which specific subcategories to target or avoid
* Look deeper into the Corporate customers' orders to see why exactly there's a loss in profit
* Look deeper into the Central and South regions to see if it's connected to the Corporate customer segment
* Look into the East and West regions to see what is contributing to the high profits
* Find the cause of the extreme YoY changes in the Furniture product category
* See how the discount and quantities factor into any growth and losses


