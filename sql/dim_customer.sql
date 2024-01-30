SQL=$(cat <<EOF

INSERT INTO public.dim_customer
(customer_id, first_name, last_name, full_name, email, create_date, expire_date)
select c.customer_id, c.first_name, c.last_name, 
c.first_name || ' ' || c.last_name as full_name,
c.email,
'2005-01-01' as create_date,
'9999-12-31' as expire_date
from public.customer c;

EOF
)
