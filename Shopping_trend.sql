create database Market_Reasearch;
use Market_Reasearch;
show tables;

select*from shopping_trends;

#Total Revenue
select sum(Purchase_Amount) as Revenue from shopping_trends;

#Total Unique Customers
select count(distinct(Customer_ID)) as total_customer from shopping_trends;

#Average Purchase Amount
select avg(Purchase_Amount) as Avg_Purchase_Amount from shopping_trends;

#Maximum & Minimum Purchase Amount
select min(Purchase_Amount) as min_amount, max(Purchase_Amount) as max_amount from shopping_trends;

#Category-wise Purchases Count
select category, count(*)  as total_purchase from shopping_trends group by category order by total_purchase DESC;

#Location-wise revenue distribution
select location, sum(Purchase_Amount) as total_revenue from shopping_trends group by location order by total_revenue desc;

#Season Generates the Highest Sales
select season, sum(Purchase_Amount) as total_revenue from shopping_trends group by season order by total_revenue desc limit 1;

#Average Review Rating Category-wise
select category, avg(Purchase_Amount) as avg_total_revenue from shopping_trends group by category order by avg_total_revenue DESC;

#Repeat CustomersRepeat Customers
select customer, count(distinct customer) as repeat_customer from shopping_trends where previous_purchase>1;

#Frequency of Purchases Distribution
select frequency_of_purchase, count(distinct customer_id) as total_customer from shopping_trends group by frequency_of_purchase order by total_customer desc;

#High-Value Customers
select customer_id from shopping_trends where Purchase_Amount>(select avg(Purchase_Amount) from shopping_trends) order by purchase_amount desc;

#Age Group-wise Spending Pattern
select case when age<25 then "Under 25" when age between 25 and 34 then "25-34" when age between 35 and 44 then "35-44" when age between 45 and 54 then "45-54" else "55+" end as age_group,
sum(purchase_amount) as total_spending, round(avg(purchase_amount),2) as avg_spending from shopping_trends group by age_group order by total_spending desc;

#Gender-wise Revenue Comparison
select gender, sum(purchase_amount) as total_purchase_amount, avg(purchase_amount) as avg_purchase_amount from shopping_trends group by gender order by total_purchase_amount desc;

#Most Used Payment Method
select payment_method, count(*) as total_transcation from shopping_trends group by payment_method order by total_transcation limit 1;

#Credit Card Payment Method Match Count
select count(*) as total_credit_card_payment from shopping_trends where Payment_Method='Credit Card';

#Shipping Type-wise Revenue
select Shipping_Type, sum(purchase_amount) as total_revenue from shopping_trends group by Shipping_Type order by total_revenue desc; 

#Discount Applied vs Non-Discount Revenue Comparison
select discount_Applied, sum(purchase_amount) as total_revenue from shopping_trends group by discount_applied order by total_revenue desc;

#Promo Code user Customers
select count(distinct Customer_ID) as promo_code_customer where promo_code_used='yes';

#Top 5 Most Purchased Items
select item_purchased, count(*) as total_purchased from shopping_trends group by item_purchased order by total_purchased limit 5;

#Which Color Sells the Most?
select color, count(*) as total_sales from shopping_trends group by color order by total_sales limit 1;

#Size-wise Demand Distribution
select size, count(*) as total_sales from shopping_trends group by size order by total_sales limit 1; 

#Category Has the Highest Repeat Purchases
select category, count(*) as repeat_purchase_count from shopping_trends where previous_purchases>1 group by category order by repeat_purchase_count desc limit 1;

#Low-rated Products (Rating < 3)
select item_purchased, category, min(review_rating) as low_rating from shopping_trends group by item_purchased, category HAVING min(review_rating) < 3 order by low_rating asc;

#RFM-style segmentation(Recency ignored, Frequency + Monetary).
select customer_ID, sum(purchase_amount) as total_spend, max(previous_purchases) as frequency, case when max(previous_purchases)>=20 and sum(purchase_amount)>=500  then "High value" when max(previous_purchases)>=10 and sum(purchase_amount)>=250 then "Medium Value" else "Low Value"
end as customer_segment from shopping_trends group by customer_ID order by total_spend desc;

#Churn-prone Customers
select customer_ID, sum(purchase_amount) as total_spend, max(previous_purchase) as frequency from shopping_trends group by customer_ID having
max(previous_purchases)<=2 and sum(purchase_amount)<(select avg(purchase_amount) from shopping_trends) order by total_spend asc;

#High Rating but Low Sales Products
select item_purchased, category, round(avg(review_rating),2) as avg_rating, count(*) as total_sales from shopping_trends group by item_purchased, category having avg(review_rating)>=4
and count(*)<(select avg(cnt) from (select count(*) as cnt from shopping_trends group by item_purchased)x) order by avg_rating desc;

#Customers Responding Best to Discounts
select discount_applied, count(*) as total_orders, round(avg(purchase_amount),2) as avg_order_value from shopping_trends group by discount_applied;

#Best Performing Season + Category Combination
select season, category, sum(purchase_amount) as total_revenue, count(*) as total_orders from shopping_trends group by season, category order by total_revenue desc limit 5;

#Negative/Zero Purchase Amount
select purchase_amount<=0 from shopping_trends;

#Missing Review Ratings
select * from shopping_trends where Review_Rating is null;

#Invalid Frequency Values
select distinct frequency_of_purchases from shopping_trends where frequency_of_purchases not in ('Weekly','Fortnightly','Monthly','Quarterly','Annually');

#Duplicate Customer Records
select customer_ID, count(*) as record_count from shopping_trends group by customer_ID having count(*)>1;

#Promo Code Used but Discount = 'No'
select * from shopping_trends where promo_code_used='Yes' and discount_applied='No';

#Top 10 Customers by Lifetime Value (LTV)
select customer_ID, sum(purchase_amount) as lifetime_value, count(*) as total_orders from shopping_trends group by customer_ID order by lifetime_value desc limit 10;

#Customer Segmentation
select customer_ID , sum(purchase_amount) as total_spent, case when sum(purchase_amount)>=1000 then 'Premium' when sum(purchase_amount)>=500 then "Regular" else "Low value"
end as customer_segment from shopping_trends group by customer_ID;

#Revenue Leakage Analysis (Discount Heavy Customers)
select customer_ID, sum(purchase_amount) as discount_revenue from shopping_trends where Discount_Applied='Yes' group by customer_ID having count(*) >1 order by discount_revenue desc;

#Operational Bottlenecks (Shipping Type)
select shipping_type, count(*) as total_orders, round(avg(purchase_amount),2) as avg_order_value from shopping_trends group by shipping_type order by total_orders desc;