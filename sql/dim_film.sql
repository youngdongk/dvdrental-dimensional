SQL=$(cat <<EOF

INSERT INTO public.dim_film
(film_id, title, category, release_year, rating, length, length_label, create_date, expire_date)
SELECT f.film_id, f.title, c.name, f.release_year, f.rating, f.length, 
case 
	when f.length > 60 then 'short'
	when f.length > 120 then 'medium'
	else 'long'
end as length_lable,
'2005-01-01' as create_date,
'9999-12-31' as expired_date
FROM public.film f 
inner join public.film_category fc 
on f.film_id = fc.film_id 
inner join public.category c 
on fc.category_id = c.category_id;

EOF
)
