usecase4
----------
data sets:
----------


bq mk audit_usecase4

bq mk stg_usecase4

bq mk hist_usecase4

bq mk view_usecase4


audit tables:
--------------
create audit tables stage:
--------------------------
create table audit_usecase4.stg_audit_customers(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


create table audit_usecase4.stg_audit_geolaction(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


create table audit_usecase4.stg_audit_order_items(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


create table audit_usecase4.stg_audit_order_payments(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


create table audit_usecase4.stg_audit_order_reviews(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


create table audit_usecase4.stg_audit_orders(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)

create table audit_usecase4.stg_audit_products(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)

create table audit_usecase4.stg_audit_sellers(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)

create table audit_usecase4.stg_audit_product_category(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)

--------------------------------------------==========================
===================================================================================
create table if not exists stg_usecase4.stg_customer(
customer_id	         string, 
customer_unique_id	 string, 
customer_zip_code	 string, 
customer_city	     string, 
customer_state       string 
)

create table if not exists stg_usecase4.stg_geolocation(
geolocation_zip_code	 string,
geo_lat                  string,
geo_lng	                 string,
geo_city	             string,
geo_state                string
)

create table if not exists stg_usecase4.stg_order_items(
order_id	              string,
order_item_id	          string,
product_id	              string,
seller_id	              string,
shipping_limit_date	      string,
price	                  string,
freight_value             string

)

create table if not exists stg_usecase4.order_payments(
order_id	                     string,
payment_sequential	             string,
payment_type	                 string,
payment_installments	         string,
payment_value                    string

) 

create table if not exists stg_usecase4.order_review(
review_id	                      string,
order_id	                      string,
review_score	                  string,
review_comment_title	          string,
review_comment_message	          string,
review_creation_date	          string,
review_answer_timestamp           string

)

create table if not exists stg_usecase4.stg_orders(
order_id	                      string,
customer_id	                      string,
order_status	                  string,
order_purchase_timestamp	      string,
order_approved_at	              string,
order_delivered_carrier_date	  string,
order_delivered_customer_date	  string,
order_estimated_delivery_date     string

)

create table if not exists stg_usecase4.stg_products(
product_id	                     string,
product_category_name	         string,
product_name_lenght	             string,
product_description_lenght	     string,
product_photos_qty	             string,
product_weight_g	             string,
product_length_cm	             string,
product_height_cm	             string,
product_width_cm                 string

)

create table if not exists stg_usecase4.stg_seller(
seller_id	                  string,
seller_zip_code_prefix	      string,
seller_city	                  string,
seller_state                  string

)

create table if not exists stg_usecase4.stg_product_category(
product_category_name	            string,
product_category_name_english       string

)

insert into `audit_usecase4.stg_audit_customers`
select 'audit_usecase4' as dataset_name,
'stg_audit_customers' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `stg_usecase4.stg_customer`


insert into `audit_usecase4.stg_audit_geolaction`
select 'audit_usecase4' as dataset_name,
'stg_audit_geolaction' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `stg_usecase4.stg_geolocation`

insert into `audit_usecase4.stg_audit_order_items`
select 'audit_usecase4' as dataset_name,
'stg_audit_order_items' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `stg_usecase4.stg_order_items`

insert into `audit_usecase4.stg_audit_order_payments`
select 'audit_usecase4' as dataset_name,
'stg_audit_order_payments' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `stg_usecase4.order_payments`





---------------------
> bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.stg_customer gs://krishna_ecom/olist_customers_dataset.csv
>bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.stg_geolocation gs://krishna_ecom/olist_geolocation_dataset.csv
> bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.stg_order_items gs://krishna_ecom/olist_order_items_dataset.csv
> bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.order_payments gs://krishna_ecom/olist_order_payments_dataset.csv
> bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.stg_orders gs://krishna_ecom/olist_orders_dataset.csv
> bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.stg_products gs://krishna_ecom/olist_products_dataset.csv
> bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.stg_seller gs://krishna_ecom/olist_sellers_dataset.csv
>bq load --skip_leading_rows=1 --source_format=CSV stg_usecase4.stg_product_category gs://krishna_ecom/product_category_name_translation.csv

-------------------------------------------------------

history:
-------
create table if not exists hist_usecase4.hist_customer(
customer_id	         string, 
customer_unique_id	 string, 
customer_zip_code	 INTEGER, 
customer_city	     string, 
customer_state       string,
load_TS	          TimeStamp,
Team_id	            INTEGER 
)

create table if not exists hist_usecase4.hist_geolocation(
geolocation_zip_code	 INTEGER,
geo_lat                  float64,
geo_lng	                 float64,
geo_city	             string,
geo_state                string
) 
create table if not exists hist_usecase4.hist_order_items(
order_id	              string,
order_item_id	          INTEGER,
product_id	              string,
seller_id	              string,
shipping_limit_date	      datetime,
price	                  float64,
freight_value             float64
)

create table if not exists hist_usecase4.hist_order_payments(
order_id	                     string,
payment_sequential	             INTEGER,
payment_type	                 string,
payment_installments	         INTEGER,
payment_value                    float64,
load_TS	                       TimeStamp,
Team_id	                       INTEGER 
)

create table if not exists hist_usecase4.hist_orders(
order_id	                      string,
customer_id	                      string,
order_status	                  string,
order_purchase_timestamp	      TimeStamp,
order_approved_at	              TimeStamp,
order_delivered_carrier_date	  TimeStamp,
order_delivered_customer_date	  TimeStamp,
order_estimated_delivery_date     TimeStamp,
load_TS                       TimeStamp,
Team_id	                        INTEGER 
)

create table if not exists hist_usecase4.hist_products(
product_id	                     string,
product_category_name	         string,
product_name_lenght	             INTEGER,
product_description_lenght	     INTEGER,
product_photos_qty	             INTEGER,
product_weight_g	             INTEGER,
product_length_cm	             INTEGER,
product_height_cm	             INTEGER,
product_width_cm                 INTEGER
)
create table if not exists hist_usecase4.hist_seller(
seller_id	                  string,
seller_zip_code_prefix	      INTEGER,
seller_city	                  string,
seller_state                  string
)

create table if not exists hist_usecase4.hist_product_category(
product_category_name	            string,
product_category_name_english       string

)

=====================================
insert into hist_usecase4.hist_customer
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY customer_unique_id
      ORDER BY customer_unique_id DESC
    ) AS rn
  FROM `stg_usecase4.stg_customer`
)

SELECT
  customer_id,
  customer_unique_id,
  safe_cast(customer_zip_code as int64) as customer_zip_code ,
  UPPER(TRIM(customer_city)),
  customer_state,
 CURRENT_TIMESTAMP as load_TS,
1811 as Team_id 
FROM dedup
WHERE rn = 1
-============================================
select geolocation_zip_code,count(*) as count 
from `stg_usecase4.stg_geolocation`

group by geolocation_zip_code
having count(*) > 1 or geolocation_zip_code is null


=====================================
insert into hist_usecase4.hist_geolocation
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY geolocation_zip_code,geo_lat,geo_lng,geo_city,geo_state
      ORDER BY geolocation_zip_code DESC
    ) AS rn
  FROM `stg_usecase4.stg_geolocation`
)

SELECT
 safe_cast( geolocation_zip_code as int64) as geolocation_zip_code,
  safe_cast(geo_lat as float64) as geo_lat,
  safe_cast(geo_lng as float64) as geo_lng,
  UPPER(TRIM(geo_city)),
  geo_state,
FROM dedup
WHERE rn = 1
===============================================
insert into hist_usecase4.hist_order_items
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY order_id
      ORDER BY order_id DESC
    ) AS rn
  FROM `stg_usecase4.stg_order_items`
)

SELECT
 order_id,
safe_cast(order_item_id as INTEGER) as order_item_id,
product_id,	             
seller_id,
SAFE.PARSE_DATETIME('%m/%d/%Y %H:%M', shipping_limit_date) AS shipping_limit_date,
safe_cast(price as float64) as price,
safe_cast(freight_value as float64) as freight_value
FROM dedup
WHERE rn = 1

=================================================================
insert into hist_usecase4.hist_order_payments
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY order_id
      ORDER BY order_id DESC
    ) AS rn
  FROM `stg_usecase4.order_payments`
)

SELECT
 order_id,
safe_cast(payment_sequential as int64) as payment_sequential,
COALESCE(payment_type,'n/a') as payment_type ,         
safe_cast(payment_installments	as int64) as payment_installments,
safe_cast(payment_value as float64) as payment_value,
 CURRENT_TIMESTAMP as load_TS,
1811 as Team_id 
FROM dedup
WHERE rn = 1
============================================
insert into hist_usecase4.hist_orders
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY order_id
      ORDER BY order_purchase_timestamp DESC
    ) AS rn
  FROM `stg_usecase4.stg_orders`
)

SELECT
 order_id,	              
 customer_id,
 COALESCE(order_status,'n/a') as order_status,
 cast(order_purchase_timestamp as TimeStamp ) as order_purchase_timestamp ,
 cast(order_approved_at as TimeStamp) AS order_approved_at,
 COALESCE(TimeStamp(order_delivered_carrier_date),TimeStamp(order_approved_at)) AS order_delivered_carrier_date,
 COALESCE(TimeStamp( order_delivered_customer_date),TimeStamp(order_estimated_delivery_date)) AS order_delivered_customer_date,
 COALESCE(TimeStamp( order_estimated_delivery_date ),TimeStamp(order_delivered_customer_date)) AS order_estimated_delivery_date,
 CURRENT_TIMESTAMP as load_TS,
1811 as Team_id 
FROM dedup
WHERE rn = 1
====================================================
insert into hist_usecase4.hist_products
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY product_id
      ORDER BY product_id DESC
    ) AS rn
  FROM `stg_usecase4.stg_products`
)
SELECT
 product_id,
 COALESCE(product_category_name,'n/a') as product_category_name,
 COALESCE(safe_cast(product_name_lenght as int64),0) as product_name_lenght,
 COALESCE(safe_cast(product_description_lenght as int64),0) as product_description_lenght,
 COALESCE(safe_cast(product_photos_qty as int64),0) as product_photos_qty,
 COALESCE(safe_cast(product_weight_g as int64),0) as product_weight_g,
 COALESCE(safe_cast(product_name_lenght as int64),0) as product_name_lenght,
 COALESCE(safe_cast(product_height_cm as int64),0) as product_height_cm,
 COALESCE(safe_cast(product_height_cm as int64),0) as product_height_cm
FROM dedup
WHERE rn = 1

====================================
insert into hist_usecase4.hist_seller
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY seller_id
      ORDER BY seller_id DESC
    ) AS rn
  FROM `stg_usecase4.stg_seller`
)

SELECT
 seller_id,
 safe_cast(seller_zip_code_prefix  as int64) as seller_zip_code_prefix,
 COALESCE(seller_city'n/a') as seller_city,
 COALESCE(seller_state,seller_city)as seller_state
FROM dedup
WHERE rn = 1
======================================
insert into hist_usecase4.hist_product_category
WITH dedup AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY product_category_name
      ORDER BY product_category_name DESC
    ) AS rn
  FROM `stg_usecase4.stg_product_category`
)

SELECT
 COALESCE(product_category_name,product_category_name) as product_category_name,
 COALESCE(product_category_name,product_category_name)as product_category_name_english
FROM dedup
WHERE rn = 1

------------------------------------------------
views:
------------
create or replace view view_usecase4.product_category_total_revenue as
SELECT
  
    t.product_category_name_english,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM hist_usecase4.hist_order_items AS oi
JOIN hist_usecase4.hist_products AS p
    ON oi.product_id = p.product_id
JOIN hist_usecase4.hist_orders AS o
    ON oi.order_id = o.order_id
LEFT JOIN hist_usecase4.hist_product_category AS t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    p.product_category_name,
    t.product_category_name_english;
	
	
	create or replace view view_usecase4.product_category_total_revenue as
SELECT
    p.product_category_name,
    t.product_category_name_english,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_charges,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM hist_usecase4.hist_order_items AS oi
JOIN hist_usecase4.hist_products AS p
    ON oi.product_id = p.product_id
JOIN hist_usecase4.hist_orders AS o
    ON oi.order_id = o.order_id
LEFT JOIN hist_usecase4.hist_product_category AS t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    p.product_category_name,
    t.product_category_name_english
ORDER BY total_revenue DESC;   
======================================================
select * from  view_usecase4.vw_delivery_performance 



CREATE OR REPLACE VIEW view_usecase4.vw_delivery_performance AS

SELECT
    COUNT(*) AS total_delivered_orders,

    COUNT(
        CASE
            WHEN DATE(order_delivered_customer_date) <= DATE(order_estimated_delivery_date)
            THEN 1
        END
    ) AS on_time_orders,

    COUNT(
        CASE
            WHEN DATE(order_delivered_customer_date) > DATE(order_estimated_delivery_date)
            THEN 1
        END
    ) AS late_orders,

    ROUND(
        COUNT(
            CASE
                WHEN DATE(order_delivered_customer_date) <= DATE(order_estimated_delivery_date)
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS on_time_delivery_percentage

FROM hist_usecase4.hist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;  