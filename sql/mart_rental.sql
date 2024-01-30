SELECT
    r.rental_id,
    s.store_id,
    sc.city_id as store_city_id,
    sc.city as store_city,
    sc.country as store_country,
    f.film_id,
    f.title,
    f.category,
    f.release_year,
    f.rating,
    f.length,
    f.length_label,
    c.customer_id,
    c.full_name,
    c.email,
    cc.city_id as customer_city_id,
    cc.city as customer_city,
    cc.country as customer_counrry,
    r.rental_date,
    r.payment_date,
    r.return_date,
    r.amount,
    r.rental_duration
FROM
    public.fact_rental as r
    inner join public.dim_customer as c on r.customer_key = c.customer_key 
        and r.rental_date between c.create_date and c.expire_date
    inner join public.dim_store as s on r.store_key = s.store_key
        and r.rental_date between s.create_date and s.expire_date
    inner join public.dim_city as sc on r.store_city_key = sc.city_key
        and r.rental_date between sc.create_date and sc.expire_date
    inner join public.dim_film as f on r.film_key = f.film_key
        and r.rental_date between f.create_date and f.expire_date
    inner join public.dim_city as cc on r.customer_city_key = cc.city_key
        and r.rental_date between cc.create_date and cc.expire_date
;
