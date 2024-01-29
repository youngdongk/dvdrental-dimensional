SQL=$(cat <<EOF

INSERT INTO public.dim_city
(city_id, city, country, create_date, expire_date)
select 
c.city_id, c.city, ct.country,
current_date as create_date,
'9999-12-31' as expired_date
from public.city c
inner join public.country ct
on c.country_id = ct.country_id ;

EOF
)
