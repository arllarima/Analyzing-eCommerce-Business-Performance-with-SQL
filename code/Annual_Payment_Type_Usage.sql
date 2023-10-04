-- 1. Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit
select payment_type, count(1) as jumlah
from order_payments_dataset
group by 1
order by 2 desc;

-- 2. Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun
select
	payment_type,
	sum(case when tahun = 2016 then total else 0 end) as "2016",
	sum(case when tahun = 2017 then total else 0 end) as "2017",
	sum(case when tahun = 2018 then total else 0 end) as "2018",
	sum(total) as total_payment_type_usage
from (
	select 
		date_part('year', od.order_purchase_timestamp) as tahun,
		opd.payment_type,
		count(opd.payment_type) as total
	from orders_dataset as od
	join order_payments_dataset as opd 
		on od.order_id = opd.order_id
	group by 1, 2
	) as sub
group by 1
order by 2 desc;