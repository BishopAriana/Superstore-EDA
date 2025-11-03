# Retail Store YoY Sales and YoY Profit Analysis

---

## Data Structure
![Image of the ERD for the data](/Images/ERD.png)

---

## Methodology
I received the data as an Excel Workbook where all of the tables are in their own tab, and I converted each table to its own UTF8 CSV file in order to ingest it into the PostgresQL database. The data was manipulated with complex queries, and the query results were exported. Then, those tables were used to create the relevant data visualizations in Excel to support my findings.

---

## Results
### Customer Segment
We need to dig deeper into our Corporate customer orders over the past 2 years. It is the only segment to have a decrease in profit at all (this year - 2018), and the decrease occured even with a 16% increase in Total Sales. The other two customer segments are both in the green; however, the Home Office segment had significant positive increase both last year (2017) and this year (2018). We should focus on growth of profit from our Corporate Customers.

![Image of the YoY Customer Segment Chart](/Images/YoY_Segment_Chart.png)

### Region
The South and Central regions saw significant decrease in profits in the past year (with the Central region also seeing a slight decrease in sales). On the other hand, the East and West regions both saw increases in sales and profit. We need to look deeper into what is leading this growth.

![Image of the YoY Region Chart](/Images/YoY_Region_Chart.png)

### Product Category
The Furniture category needs to be investigated in more detail. The second and fourth year (this year) have large losses in YoY profit, but the third year has the biggest percentage of YoY growth among any category and year - 130%. The cause behind these extreme changes needs to be found before a decision can be made. The other categories performed just fine the past 2 years.

![Image of the YoY Region Chart](/Images/YoY_Category_Chart.png)

### Products
I found the Top 10 and Botton 10 products overall by both sales and profit. You can see in the Bottom 10 by Profit Chart [here](/Images/Bottom10_Products_Profit.png) that the majority of these products each year are in the Furniture category. Most of them are Tables. At the same time, none of the [bottom 10 products by sales](/Images/Bottom10_Products_Sales.png) have ever been a Furniture Product (it's mostly office supplies). Most of the top 10 products by [sales](/Images/Top10_Products_Sales.png) AND by [profit](/Images/Top10_Products_Profit.png) are in the Technology category. These are printers, copiers, and communication devices (phones and headsets). There are Furniture products in the top 10 product lists, so the category shouldn't be avoided altogether. I suggest a more thorough look into the Table and Bookcase subcategories.

---

## Next Steps
* Look deeper into the Corporate customers' orders as well as South and East region orders to see why exactly there's a decrease in profit in the past year
* Look into the East and West regions to see what is contributing to the high profit increase
* Find the cause of the extreme YoY changes in the Furniture product category



