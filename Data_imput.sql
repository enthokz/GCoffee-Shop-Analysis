-- Create Database
create database gcoffee;
show tables;
describe stores;
select *
	from user_2504;

alter table stores
	modify store_id int primary key not null,
    modify store_name varchar(60),
    modify street varchar(50),
    modify city varchar(50),
    modify state varchar(50),
    modify latitude float,
    modify longitude float;

-- import data
create table menu_items(
	item_id int primary key not null,
    item_name varchar(30),
    category varchar(30),
    price float,
    is_seasonal varchar(30),
    available_from text,
    available_to text);
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/menu_items.csv"
	into table menu_items
    fields terminated by ','
    ignore 1 lines;
select * from menu_items;

create table payment_methods(
	method_id int primary key not null,
    method_name varchar(30),
    category varchar(30));
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/payment_methods.csv"
	into table payment_methods
    fields terminated by ','
    ignore 1 lines;
select * from payment_methods;

create table vouchers(
	voucher_id int primary key not null,
    voucher_code varchar(30),
    discount_type varchar(30),
    discount_value float,
    valid_from date,
    valid_to date);
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/vouchers.csv"
	into table vouchers
    fields terminated by ','
    ignore 1 lines;
select * from vouchers;

create table user_2504(
	user_id int primary key not null,
    gender varchar(30),
    birthdate date,
    registered_at datetime);
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/users_202504.csv"
	into table user_2504
    fields terminated by ','
    ignore 1 lines;
select * from user_2504;

create table user_2505(
	user_id int primary key not null,
    gender varchar(30),
    birthdate date,
    registered_at datetime);
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/users_202505.csv"
	into table user_2505
    fields terminated by ','
    ignore 1 lines;
select * from user_2505;

create table user_2506(
	user_id int primary key not null,
    gender varchar(30),
    birthdate date,
    registered_at datetime);
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/users_202506.csv"
	into table user_2506
    fields terminated by ','
    ignore 1 lines;
select * from user_2506;

create table trx_2504(
	transaction_id varchar(50) primary key not null,
    store_id int,
    payment_method_id int,
    voucher_id int ,
    user_id int,
    original_amount float,
    discount_applied float,
    final_amount float,
    created_at datetime,
    foreign key (store_id) references stores(store_id),
    foreign key (payment_method_id) references payment_methods(method_id),
    foreign key (voucher_id) references vouchers(voucher_id))
    engine= InnoDB;
drop table trx_2504;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/transactions_202504.csv"
	into table trx_2504
    fields terminated by ','
    ignore 1 lines
    (transaction_id,store_id,payment_method_id,@voucher_id,@user_id,original_amount,discount_applied,final_amount,created_at)
    set voucher_id= nullif(@voucher_id,''),user_id=nullif(@user_id,'');
select count(*) from trx_2504;

create table trx_2505(
	transaction_id varchar(50) primary key not null,
    store_id int,
    payment_method_id int,
    voucher_id int ,
    user_id int,
    original_amount float,
    discount_applied float,
    final_amount float,
    created_at datetime,
    foreign key (store_id) references stores(store_id),
    foreign key (payment_method_id) references payment_methods(method_id),
    foreign key (voucher_id) references vouchers(voucher_id))
    engine= InnoDB;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/transactions_202505.csv"
	into table trx_2505
    fields terminated by ','
    ignore 1 lines
    (transaction_id,store_id,payment_method_id,@voucher_id,@user_id,original_amount,discount_applied,final_amount,created_at)
    set voucher_id= nullif(@voucher_id,''),user_id=nullif(@user_id,'');
select count(*) from trx_2505;

create table trx_2506(
	transaction_id varchar(50) primary key not null,
    store_id int,
    payment_method_id int,
    voucher_id int ,
    user_id int,
    original_amount float,
    discount_applied float,
    final_amount float,
    created_at datetime,
    foreign key (store_id) references stores(store_id),
    foreign key (payment_method_id) references payment_methods(method_id),
    foreign key (voucher_id) references vouchers(voucher_id))
    engine= InnoDB;
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/transactions_202506.csv"
	into table trx_2506
    fields terminated by ','
    ignore 1 lines
    (transaction_id,store_id,payment_method_id,@voucher_id,@user_id,original_amount,discount_applied,final_amount,created_at)
    set voucher_id= nullif(@voucher_id,''),user_id=nullif(@user_id,'');
select count(*) from trx_2506;

create table items_2504(
	transaction_id varchar(50) not null,
    item_id int,
    quantity int,
    unit_price float,
    subtotal float,
    created_at datetime,
    foreign key (item_id) references menu_items(item_id));
 load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/items_2504.csv"
	into table items_2504
    fields terminated by ','
    ignore 1 lines;
select * from items_2504;

create table items_2505(
	transaction_id varchar(50) not null,
    item_id int,
    quantity int,
    unit_price float,
    subtotal float,
    created_at datetime,
    foreign key (item_id) references menu_items(item_id));
 load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/items_2505.csv"
	into table items_2505
    fields terminated by ','
    ignore 1 lines;
select * from items_2505;

create table items_2506(
	transaction_id varchar(50) not null,
    item_id int,
    quantity int,
    unit_price float,
    subtotal float,
    created_at datetime,
    foreign key (item_id) references menu_items(item_id));
 load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Data/gcoffee/items_2506.csv"
	into table items_2506
    fields terminated by ','
    ignore 1 lines;
select * from items_2506;
