show tables;
-- virtual tabel for trx 2025
create view trx_25 as
	select *
	from trx_2504
union
	select *
	from trx_2505
union
	select *
	from trx_2506;
select count(*) from trx_25;

-- VIrtual tabel for trx 2024
create view trx_24 as
		select *
		from trx_2404
	union
		select *
		from trx_2405
	union 
		select *
        from trx_2406;
select count(*) from trx_24;

-- Virtual tabel for items 2025
create view items_25 as
		select *
		from items_2504
	union
		select *
		from items_2505
	union
		select *
		from items_2506;
select count(*) from items_25;

-- Total income
 with ab as(
select extract(month from created_at) as month, sum(final_amount) as total_revenue,
	count(*) as number_customer
	from trx_25
    group by month
    order by month
    ),
    ac as(
select extract(month from created_at) as month, sum(final_amount) as total_revenue,
	count(*) as number_customer
	from trx_24
    group by month
    order by month),
    av as(
select case when az.month=4 then 'April'
		when az.month=5 then 'Mei'
        when az.month=6 then 'June'
	end months,
    round(az.total_revenue,2) as revenue_2025,
    round(ax.total_revenue,2) as revenue_2024,
    round(az.number_customer,2) as customer_2025,
    round(ax.number_customer,2) as customer_2024
	from ab az
    join ac ax
    on az.month=ax.month)
select months,revenue_2024,revenue_2025,
	round(((revenue_2025-revenue_2024)/revenue_2024)*100,2) as revenue_vs_last_year,
    customer_2024,
    customer_2025,
    round(((customer_2025-customer_2024)/customer_2024)*100,2) as cust_vs_last_year
	from av;

-- Whice store was underperformed
with aa as(
select store_id, round(sum(final_amount),2) as total_value
	from trx_25
    group by store_id)
select az.store_id, store_name,state, total_value
	from aa az
    join stores ax
    on az.store_id=ax.store_id
    order by total_value;
    
-- Number of customer from each site
with aa as(
select store_id, count(distinct transaction_id)  as number_cust
	from trx_25
    group by store_id)
select rank() over(order by number_cust desc) as ranking, az.store_id, store_name, state, number_cust
	from aa az
    join stores ax
    on az.store_id=ax.store_id
    order by ranking desc;

-- Is there lack of cust based on region sales?
with aa as(
select store_id, count(distinct transaction_id)  as number_cust
	from trx_25
    group by store_id)
select state, round(avg(number_cust),2) as avg_cust
	from aa az
    join stores ax
    on az.store_id=ax.store_id
    group by state
    order by avg_cust;

-- What best and underperform product 
with aa as(
select az.transaction_id,ax.item_id, quantity, ac.item_name 
	from trx_25 az
    join items_2504 ax
    on az.transaction_id=ax.transaction_id
    join menu_items ac
    on ax.item_id=ac.item_id
    where store_id=6)
select item_id, item_name, sum(quantity) as qty_ordered
	from aa
    group by item_id,item_name;
    
-- Purchase by Member
with aa as(
select extract(month from created_at) as month, count(*) as purchase_member
	from trx_25
    where user_id is not null
    group by month
    order by month),
	aq as(
select extract(month from created_at) as month, count(*) as purchase_nonmember
	from trx_25
    where user_id is null
    group by month
    order by month)
select az.month, purchase_member, purchase_nonmember
	from aa az
    join aq ax
    on az.month=ax.month;
    
-- Any voucher for member used?
with aa as(
select distinct voucher_id, count(*) as number_used_member,
	case when voucher_id is null
		then 'No-voucher'
        else voucher_id
	end voucher_applied
	from trx_25
    where user_id is not null
    group by voucher_id),
	ab as(
select distinct voucher_id, count(*) as number_used_nonmember,
	case when voucher_id is null
		then 'No-voucher'
        else voucher_id
	end voucher_applied
	from trx_25
    where user_id is null
    group by voucher_id),
    ac as(
select aa.voucher_applied, number_used_member, number_used_nonmember,aa.voucher_id
	from aa
    join ab
    on aa.voucher_applied=ab.voucher_applied)
select voucher_applied, voucher_code, discount_value,number_used_member,number_used_nonmember
	from ac
    left join vouchers am
    on ac.voucher_id=am.voucher_id;

-- Best Seller Product
select distinct az.item_id, item_name, category,sum(quantity) as total_qty, sum(subtotal) as total_price
	from items_25 az
    join menu_items ax
    on az.item_id=ax.item_id
    group by az.item_id, item_name,category;
    



select *
	FROM trx_2504;
select store_name, postal_code, lag(postal_code) over(order by store_name) as selisih
	from stores;