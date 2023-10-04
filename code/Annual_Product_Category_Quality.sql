-- 1. Membuat tabel yang berisi informasi pendapatan/revenue perusahaan total untuk masing-masing tahun
create table total_revenue as
		select
			  date_part('year', od.order_purchase_timestamp) as tahun,
			  sum(oid.price + oid.freight_value) as revenue
		from order_items_dataset as oid
		join orders_dataset as od on oid.order_id = od.order_id
		where od.order_status = 'delivered'
		group by 1
		order by 1;
		
-- 2. Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun
create table cancelled_order as
		select
			  date_part('year', order_purchase_timestamp) as tahun,
			  count(order_id) as total_cancel
		from orders_dataset
		where order_status = 'canceled'
		group by 1
		order by 1;
		
-- 3. Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun
create table top_product_category as
		select
			   tahun,
			   kategori_produk,
			   revenue
		from (
			  select 
					date_part('year', od.order_purchase_timestamp) as tahun,
					pd.product_category_name as kategori_produk,
					sum(oid.price + oid.freight_value) as revenue,
					rank() over(partition by
											date_part('year', od.order_purchase_timestamp) 
									order by 
											sum(oid.price + oid.freight_value) desc) as ranking
			  from order_items_dataset as oid
			  join orders_dataset as od on od.order_id = oid.order_id
			  join product_dataset as pd on pd.product_id = oid.product_id
		   	  where od.order_status = 'delivered'
			  group by 1,2
			  order by 1
			  ) subq
		where ranking = 1;
		
-- 4. Membuat tabel yang berisi nama kategori produk yang memiliki jumlah cancel order terbanyak untuk masing-masing tahun
create table top_cancelled_product as
		select
			   tahun,
			   kategori_produk,
			   total_cancel
		from (
			  select 
					date_part('year', od.order_purchase_timestamp) as tahun,
					pd.product_category_name as kategori_produk,
					count(od.order_id) as total_cancel,
					rank() over(partition by
											date_part('year', od.order_purchase_timestamp) 
									order by 
											count(od.order_id) desc) as ranking
			  from order_items_dataset as oid
			  join orders_dataset as od on od.order_id = oid.order_id
			  join product_dataset as pd on pd.product_id = oid.product_id
		   	  where od.order_status = 'canceled'
			  group by 1,2
			  order by 1
			  ) subq
		where ranking = 1;
		
-- 5. Menggabungkan informasi-informasi yang telah didapatkan ke dalam satu tampilan tabel
select 
        tr.tahun as year,
		round(tr.revenue::numeric, 2) as total_revenue,
		tpc.kategori_produk as top_category_product,
		round(tpc.revenue::numeric, 2) as total_revenue_top_product,
		co.total_cancel,
		tcp.kategori_produk AS top_canceled_product,
		tcp.total_cancel AS total_top_canceled_product
from total_revenue as tr
join
	top_product_category as tpc on tr.tahun = tpc.tahun
join
	cancelled_order as co on tpc.tahun = co.tahun
join
	top_cancelled_product as tcp on co.tahun = tcp.tahun;
