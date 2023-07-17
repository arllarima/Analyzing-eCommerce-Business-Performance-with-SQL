# Analyzing-eCommerce-Business-Performance-with-SQL
Project ini dibuat untuk menganalisis kasus performansi bisnis eCommerce.<br>
**Dataset** : Disediakan oleh Rakamin Academy <br>
**Tools** : PostgreSQL <br>
**Visualization** : Google Data Studio <br>

## Overview
Dalam suatu perusahaan, mengukur performa bisnis sangatlah penting untuk melacak, memantau, dan menilai keberhasilan atau kegagalan dari berbagai proses bisnis. Oleh karena itu, dalam project ini akan menganalisa performa bisnis untuk sebuah perusahan eCommerce,  dengan memperhitungkan beberapa metrik bisnis yaitu: <br>
1. Annual Customer Activity Growth <br>
2. Annual Product Category Quality <br>
3. Annual Payment Type Usage <br>

## Data Preparation
Sebelum memulai pemrosesan data, tahap paling awal yang harus dilakukan adalah mempersiapkan data mentah menjadi data yang terstruktur dan siap diolah. <br>
Dataset yang digunakan adalah dataset semua pemesanan dari sebuah perusahaan e-Commerce dari tahun 2016 – 2018. Di dalam dataset ini terdapat 8 tabel yang berinteraksi satu sama lain. Maka langkah-langkah yang dilakukan selanjutnya adalah sebagai berikut: <br>
1. Buat database baru beserta tabel-tabelnya untuk data yang sudah disiapkan, dengan memperhatikan tipe data masing-masing kolom. <br>
2. Impor data CSV ke database. <br>
3. Menentukan Primary Key dan Foreign Key dengan alter table. <br>
4. Membuat dan mengeksport ERD (Entity Relationship Diagram). <br>

<details>
  <summary>Click untuk melihat Queries</summary>
  
  ``` sql
  -- 1. Membuat tabel
CREATE TABLE customers_dataset (
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix varchar,
	customer_city varchar,
	customer_state varchar
	);
	
CREATE TABLE sellers_dataset (
	seller_id varchar,
	seller_zip_code_prefix varchar,
	seller_city varchar,
	seller_state varchar
	);
	
CREATE TABLE geolocation_dataset (
	geolocation_zip_code_prefix int,
	geolocation_lat decimal,
	geolocation_lng decimal,
	geolocation_city varchar,
	geolocation_state varchar
	);
	
CREATE TABLE product_dataset (
	no_id int,
	product_id varchar,
	product_category_name varchar,
	product_name_lenght double precision,
	product_description_lenght double precision,
	product_photos_qty double precision,
	product_weight_g double precision,
	product_length_cm double precision,
	product_height_cm double precision,
	product_width_cm double precision
	);
	
CREATE TABLE orders_dataset (
	order_id varchar,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp
	);
	
CREATE TABLE order_items_dataset (
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price decimal,
	fright_value decimal
	);
	
CREATE TABLE order_payments_dataset (
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installments int,
	payment_value decimal
	);
	
CREATE TABLE order_reviews_dataset (
	review_id varchar,
	order_id varchar,
	review_score int,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
	);
	
-- 2. Menginput isi tabel dengan file csv, klik kanan pada nama tabel > Import/Export Data


-- 3. Menentukan Primary Key dan Foreign Key
-- Primary Key
alter table customers_dataset add primary key(customer_id);
alter table sellers_dataset add primary key(seller_id);
alter table product_dataset add primary key(product_id);
alter table orders_dataset add primary key(order_id);

-- Foregin Key
alter table orders_dataset add foreign key (customer_id) references customers_dataset;
alter table order_payments_dataset add foreign key (order_id) references orders_dataset;
alter table order_reviews_dataset add foreign key (order_id) references orders_dataset;
alter table order_items_dataset add foreign key (order_id) references orders_dataset;
alter table order_items_dataset add foreign key (product_id) references product_dataset;
alter table order_items_dataset add foreign key (seller_id) references sellers_dataset;

-- 4. Membuat ERD dengan cara klik kanan pada database ecommerce > Generate ERD
```
</details>

**Hasil ERD:** <br>
<p align="center">
![image](https://github.com/arllarima/Analyzing-eCommerce-Business-Performance-with-SQL/assets/130117653/d105e9cf-3b55-4578-be82-a85d5b1d77df)<br>
Gambar 1. Entity Relationship Diagram
</p>
<br>
<br>




