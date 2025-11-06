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
select * from trx_25;

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
	union all
		select *
		from items_2505
	union all
		select *
		from items_2506;
select * from items_25;
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
select store_id, round(sum(final_amount),2) as total_value, count(distinct transaction_id) as total_cust
	from trx_25
    group by store_id)
select az.store_id, store_name,state, total_value, total_cust
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
select store_id, count(distinct transaction_id)  as number_cust, sum(final_amount) as revenu
	from trx_25
    group by store_id),
    ab as(
select store_id,count(distinct transaction_id) as cust_number, sum(final_amount) as reven
	from trx_24
    group by store_id)
select state, round(avg(cust_number),2) as avg_cust_24, round(avg(number_cust),2) as avg_cust_25,
round(avg(reven),2) as avg_revenue_24, round(avg(revenu),2) as avg_revenue_25
	from aa az
    left join stores ax
    on az.store_id=ax.store_id
    left join ab
    on ab.store_id=az.store_id
    group by state;
    
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

-- Pull data for cohort and basket analysis from store_id 6
with ad as(
select transaction_id, user_id
	from trx_25
    where store_id=6)
select ad.transaction_id,user_id, az.item_id,item_name, category, quantity,subtotal
	from ad
    left join items_25 az
    on ad.transaction_id=az.transaction_id
    left join menu_items ax
    on az.item_id=ax.item_id;
    
-- Average Order Value
with arp as(
	select store_id, round(sum(final_amount),2) as revenue, count(transaction_id) as num_cust
		from trx_25
        group by store_id
        order by store_id)
select state, round(avg(revenue),2) as avg_reveue, round(avg(num_cust),2) as avg_num_cust, round(avg(revenue/num_cust),2) as AOV
	from arp az
    left join stores ax
    on az.store_id=ax.store_id
    group by state;

select item_id, sum(subtotal), sum(quantity)
	from items_25
    group by item_id;
show tables;
select * from stores;