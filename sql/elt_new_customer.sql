SQL=$(cat <<EOF

-- new customer
create or replace view vw_new_customer as 
select 
c.customer_id,
c.first_name,
c.last_name,
c.first_name || ' ' || c.last_name as fullname,
c.email,
current_date
from public.customer c
where create_date = ${TARGET_DATE};

-- Add new records to dim_customers.
-- Set expiration date to 9999-12-31. Do not set null.
INSERT INTO public.dim_customer
(customer_id, first_name, last_name, full_name, email, create_date, expire_date)
select vnc.customer_id, vnc.first_name, vnc.last_name, vnc.fullname, vnc.email, ${TARGET_DATE}, '9999-12-31'
from vw_new_customer vnc;

EOF
)
