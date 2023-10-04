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
