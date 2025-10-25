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

-- Total income
 with ab as(
select extract(month from created_at) as month, sum(final_amount) as total_revenue
	from trx_month
    group by month
    order by month
    )
select case when month=4 then 'April'
		when month=5 then 'Mei'
        when month=6 then 'June'
	end months,
    round(total_revenue,2) as total_revenue
	from ab;

-- Whice store was underperformed
with aa as(
select store_id, round(sum(final_amount),2) as total_value
	from trx_month
    group by store_id)
select az.store_id, store_name,state, total_value
	from aa az
    join stores ax
    on az.store_id=ax.store_id
    order by total_value;
    
-- Number of customer from each site
with aa as(
select store_id, count(distinct transaction_id)  as number_cust
	from trx_month
    group by store_id)
select rank() over(order by number_cust desc) as ranking, az.store_id, store_name, state, number_cust
	from aa az
    join stores ax
    on az.store_id=ax.store_id
    order by ranking desc;

-- Is there lack of cust based on region sales?
with aa as(
select store_id, count(distinct transaction_id)  as number_cust
	from trx_month
    group by store_id)
select state, round(avg(number_cust),2) as avg_cust
	from aa az
    join stores ax
    on az.store_id=ax.store_id
    group by state
    order by avg_cust;

select store_name, postal_code, lag(postal_code) over(order by store_name) as selisih
	from stores;