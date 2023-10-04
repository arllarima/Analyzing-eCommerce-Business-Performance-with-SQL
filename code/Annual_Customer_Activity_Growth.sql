-- 1. rata-rata jumlah customer aktif bulanan (monthly active user) untuk setiap tahun
select tahun, round(avg(total_customer)) as rata2_customer_aktif
from (
	  select date_part('year', od.order_purchase_timestamp) as tahun,
		     date_part('month', od.order_purchase_timestamp) as bulan,
	         count(distinct cd.customer_unique_id) as total_customer
	  from orders_dataset as od
	  join customers_dataset as cd
	  on od.customer_id = cd.customer_id
	  group by 1, 2
      ) as tabel_a
group by 1
order by 1;

-- 2. Jumlah customer baru pada masing-masing tahun
select tahun, count(customer_unique_id) as total_customer_baru
from (
	   select min(date_part('year', od.order_purchase_timestamp)) as tahun,
	          cd.customer_unique_id
	   from orders_dataset as od
	   join customers_dataset as cd
	   on od.customer_id = cd.customer_id
	   group by 2
	  ) as tabel_a
group by 1
order by 1;

-- 3. jumlah customer yang melakukan pembelian lebih dari satu kali (repeat order) pada masing-masing tahun
select tahun, count(customer_unique_id) as total_cust_repeat_order
from (
	  select date_part('year', od.order_purchase_timestamp) as tahun,
 	         cd.customer_unique_id,
 		     count(od.order_id) as total_order
	  from orders_dataset as od
	  join customers_dataset as cd
	  on od.customer_id = cd.customer_id
	  group by 1, 2
	  having count(2) > 1
	 ) as tabel_a
group by 1
order by 1;

-- 4. rata-rata jumlah order yang dilakukan customer untuk masing-masing tahun
select tahun, round(avg(total_order), 2) as rata2_frekuensi_order
from (
	  select date_part('year', od.order_purchase_timestamp) as tahun,
 	         cd.customer_unique_id,
 		     count(distinct order_id) as total_order
	  from orders_dataset as od
	  join customers_dataset as cd
	  on od.customer_id = cd.customer_id
	  group by 1, 2
	 ) as tabel_a
group by 1
order by 1;

-- 5. Menggabungkan ketiga metrik yang telah berhasil ditampilkan menjadi satu tampilan tabel
with tbl_mau as (
				select tahun, round(avg(total_customer)) as rata2_customer_aktif
				from (
					  select date_part('year', od.order_purchase_timestamp) as tahun,
							 date_part('month', od.order_purchase_timestamp) as bulan,
							 count(distinct cd.customer_unique_id) as total_customer
					  from orders_dataset as od
					  join customers_dataset as cd
					  on od.customer_id = cd.customer_id
					  group by 1, 2
					  ) as tabel_a
				group by 1
				order by 1
				),
				
tbl_new_cust as (
				select tahun, count(customer_unique_id) as total_customer_baru
				from (
					   select min(date_part('year', od.order_purchase_timestamp)) as tahun,
							  cd.customer_unique_id
					   from orders_dataset as od
					   join customers_dataset as cd
					   on od.customer_id = cd.customer_id
					   group by 2
					  ) as tabel_a
				group by 1
				order by 1),
				
tbl_repeat_order as (
					select tahun, count(customer_unique_id) as total_cust_repeat_order
					from (
						  select date_part('year', od.order_purchase_timestamp) as tahun,
								 cd.customer_unique_id,
								 count(od.order_id) as total_order
						  from orders_dataset as od
						  join customers_dataset as cd
						  on od.customer_id = cd.customer_id
						  group by 1, 2
						  having count(2) > 1
						 ) as tabel_a
					group by 1
					order by 1),
					
tbl_avg_order as (
				select tahun, round(avg(total_order), 2) as rata2_frekuensi_order
				from (
					  select date_part('year', od.order_purchase_timestamp) as tahun,
							 cd.customer_unique_id,
							 count(distinct order_id) as total_order
					  from orders_dataset as od
					  join customers_dataset as cd
					  on od.customer_id = cd.customer_id
					  group by 1, 2
					 ) as tabel_a
				group by 1
				order by 1)
				
select t_mau.tahun as tahun,
	   rata2_customer_aktif,
	   total_customer_baru,
	   total_cust_repeat_order,
	   rata2_frekuensi_order
from 
	 tbl_mau as t_mau
	 join
	 	tbl_new_cust as tnc on t_mau.tahun = tnc.tahun
	 join
	 	tbl_repeat_order as tro on tnc.tahun = tro.tahun
	 join
	 	tbl_avg_order as tao on tro.tahun = tao.tahun
group by 1, 2, 3, 4, 5
order by 1;
			