SQL=$(cat <<EOF

--insert
INSERT INTO public.dim_store
(store_id, create_date, expire_date)
select 
s.store_id, 
'2005-01-01' as create_date,
'9999-12-31' as expired_date
from public.store s ;

EOF
)
