SQL=$(cat <<EOF

-- updated customer;
-- Detects customer information updates
-- Create md5 checksum with combination of cusotmer_id, first_name, last_name, email
create or replace view vw_update_customer as 
select 
c.customer_id,
c.first_name,
c.last_name,
c.email,
md5(c.customer_id || c.first_name || c.last_name || c.email) as checksum
from public.customer c
where last_update::date = ${TARGET_DATE}
order by c.customer_id;

-- create checklist
-- Create a view to determine what is recorded in dim_customer by comparing md5 checsum
create or replace view vw_check_dim_customer as
SELECT dc.customer_id,
dc.first_name,
dc.last_name,
dc.email,
md5(dc.customer_id || dc.first_name || dc.last_name || dc.email) as checksum
FROM public.dim_customer dc
where dc.customer_id in (
	select vuc.customer_id
	from vw_update_customer vuc
)
and dc.expire_date = '9999-12-31';


-- insert new record
-- Generate a new surrogate_key and add a record for the customer_id that has changed
-- Natural Key (customer_id) keeps the same value
INSERT INTO public.dim_customer
(customer_id, first_name, last_name, full_name, email, create_date, expire_date)
select vudc.customer_id, vudc.first_name, vudc.last_name, vudc.first_name || vudc.last_name as fullname,
vudc.email, ${TARGET_DATE}, '9999-12-31'
from vw_check_dim_customer vcdc
inner join vw_update_customer vudc on vcdc.customer_id = vudc.customer_id
where vcdc.checksum != vudc.checksum;


-- update prev record
-- Update expiration date of old records to expire
with t1 as (
	select row_number() over(partition by dc.customer_id order by dc.customer_key desc) as rownum,
	customer_key, create_date, expire_date from 
	public.dim_customer dc
),
t2 as (
	select * from t1
	where rownum > 1
	and expire_date = '9999-12-31'
)
update public.dim_customer
set expire_date = (to_date(${TARGET_DATE},'YYYY-MM-DD') - interval '1 day')
where customer_key in (
	select customer_key from t2
);

EOF
)
