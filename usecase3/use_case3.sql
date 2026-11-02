use-case3:
----------
create bucket:
-------------
gcloud storage buckets create gs://krishna_usecase3
copy data from local to gcs:
------------------------------
gcloud storage cp C:\Users\arati\OneDrive\Desktop\vaarahi\usecase3\customers.csv gs://krishna_usecase3

gcloud storage cp C:\Users\arati\OneDrive\Desktop\vaarahi\usecase3\products.csv gs://krishna_usecase3

gcloud storage cp C:\Users\arati\OneDrive\Desktop\vaarahi\usecase3\sales_transactions.csv gs://krishna_usecase3

gcloud storage cp C:\Users\arati\OneDrive\Desktop\vaarahi\usecase3\stores.csv gs://krishna_usecase3

create datasets:
--------------------
bq mk audit_usecase3

bq mk bronze_usecase3

bq mk silver_usecase3
------------------------------
create audit tables silver
---------------------
create table audit_usecase3.silver_audit_customers(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


create table audit_usecase3.silver_audit_products(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)



create table audit_usecase3.silver_audit_sales_transactions(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)



create table audit_usecase3.silver_audit_stores(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


insert into `audit_usecase3.silver_audit_customers`
select 'audit_usecase3' as dataset_name,
'silver_audit_customers' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `bronze_usecase3.customers`


insert into `audit_usecase3.silver_audit_products`
select 'audit_usecase3' as dataset_name,
'silver_audit_products' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `bronze_usecase3.products`

insert into `audit_usecase3.silver_audit_sales_transactions`
select 'audit_usecase3' as dataset_name,
'silver_audit_sales_transactions' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `bronze_usecase3.sales_transactions`

insert into `audit_usecase3.silver_audit_stores`
select 'audit_usecase3' as dataset_name,
'silver_audit_stores' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `bronze_usecase3.stores`


----------------------------------------------
create tables:
------------
create table if not exists bronze_usecase3.customers(
customer_id 	STRING
customer_name	STRING
email	        STRING
phone	        STRING
address	       STRING
join_date	   STRING

)

>  bq load --skip_leading_rows=1 --source_format=CSV aratikatla2001:bronze_usecase3.customers gs://krishna_usecase3/customers.csv



create table if not exists bronze_usecase3.products(
product_id	    STRING
product_name	STRING
category	    STRING
price	        STRING

)

bq load --skip_leading_rows=1 --source_format=CSV aratikatla2001:bronze_usecase3.products gs://krishna_usecase3/products.csv 

create table if not exists bronze_usecase3.sales_transactions(
transaction_id	STRING
product_id	    STRING
store_id	    STRING
customer_id	    STRING
quantity	    STRING
sale_date	    STRING
sale_amount  	STRING

)


bq load --skip_leading_rows = 1 --source_format = CSV  aratikatla2001:bronze_usecase3.sales_transactions gs://krishna_usecase3/sales_transactions.csv 

create table if not exists bronze_usecase3.stores(
store_id	STRING
store_name	STRING
location	STRING
store_type	STRING

)

bq load --skip_leading_rows=1 --source_format=CSV aratikatla2001:bronze_usecase3.stores gs://krishna_usecase3/stores.cs

-------------------------------------------------------
create table if not exists aratikatla2001.silver_usecase3.customers(
customer_id	INTEGER,
customer_name	STRING,
email	STRING,
phone	STRING,
address	STRING,
join_date	DATE,
load_TS	TimeStamp,
Team_id	INTEGER

)

create table if not exists aratikatla2001.silver_usecase3.products(
product_id	INTEGER,
product_name	STRING,
category	STRING,
price	FLOAT64,
load_TS	TimeStamp,
Team_id	INTEGER
)
create table if not exists aratikatla2001.silver_usecase3.sales_transactions(
transaction_id	INTEGER
product_id	INTEGER
store_id	INTEGER
customer_id	INTEGER
quantity	INTEGER
sale_date	DATE
sale_amount	FLOAT
)

create table if not exists aratikatla2001.silver_usecase3.stores(
store_id	INTEGER,
store_name	STRING,
location	STRING,
store_type	STRING
)

--------------------------
create table audit_usecase3.gold_audit_customers(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)


create table audit_usecase3.gold_audit_products(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)



create table audit_usecase3.gold_audit_sales_transactions(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)



create table audit_usecase3.gold_audit_stores(
  dataset_name string,
  table_name string,
  date_audit date,
  total_record_count int64,
  audited_by string
)

insert into `audit_usecase3.gold_audit_customers`
select 'audit_usecase3' as dataset_name,
'gold_audit_customers' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `silver_usecase3.customers`

insert into `audit_usecase3.gold_audit_products`
select 'audit_usecase3' as dataset_name,
'gold_audit_products' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `silver_usecase3.products`

insert into `audit_usecase3.gold_audit_sales_transactions`
select 'audit_usecase3' as dataset_name,
'gold_audit_sales_transactions' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `silver_usecase3.sales_transactions`

insert into `audit_usecase3.gold_audit_stores`
select 'audit_usecase3' as dataset_name,
'gold_audit_stores' as table_name,
current_date() as date_audit,
count(*) as total_record_count,
"krishna-1811" as audited_by
from `silver_usecase3.stores`


---------------------------------------
insert data into gold layer:
---------------------

insert into `aratikatla2001.silver_usecase3.customers`
select
cast(customer_id	INTEGER),
customer_name	STRING,
email	STRING,
phone	STRING,
address	STRING,
join_date	DATE,
load_TS	TimeStamp,
Team_id	INTEGER


