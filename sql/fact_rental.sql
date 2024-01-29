SQL=$(cat <<EOF

with nk_fact_rental as (
    select
        r.rental_id,
        st.store_id,
        r.rental_date,
        c.city_id as store_city_id,
        f.film_id,
        ct.customer_id,
        c2.city_id as customer_city_id,
        p.payment_date,
        r.return_date,
        p.amount,
        f.rental_duration
    from
        public.rental r
        inner join public.payment p on r.rental_id = p.rental_id
        inner join public.staff s on r.staff_id = s.staff_id
        inner join public.store st on s.store_id = st.store_id
        inner join public.address a on s.address_id = a.address_id
        inner join public.city c on a.city_id = c.city_id
        inner join public.inventory i on r.inventory_id = i.inventory_id
        inner join public.film f on i.film_id = f.film_id
        inner join public.customer ct on r.customer_id = ct.customer_id
        inner join public.address a2 on ct.address_id = a2.address_id
        inner join public.city c2 on a2.city_id = c2.city_id
),
srk_fact_rental as (
    SELECT
        fr.rental_id,
        ds.store_key,
        fr.rental_date,
        dc.city_key as store_city_key,
        df.film_key,
        dcs.customer_key,
        dc2.city_key as customer_city_key,
        fr.payment_date,
        fr.return_date,
        fr.amount,
        fr.rental_duration
    FROM
        nk_fact_rental fr
        inner join public.dim_store ds on fr.store_id = ds.store_id
        inner join public.dim_city dc on fr.store_city_id = dc.city_id
        inner join dim_film df on fr.film_id = df.film_id
        inner join dim_customer dcs on fr.customer_id = dcs.customer_id
        inner join dim_city dc2 on fr.customer_city_id = dc2.city_id
),
dedup_fact_rental as (
    select
        *
        ,rank() over(partition by rental_id order by payment_date) as rnk
    from
        srk_fact_rental
)
INSERT INTO
    public.fact_rental (
        rental_id,
        store_key,
        rental_date,
        store_city_key,
        film_key,
        customer_key,
        customer_city_key,
        payment_date,
        return_date,
        amount,
        rental_duration
    )
select
    rental_id,
    store_key,
    rental_date,
    store_city_key,
    film_key,
    customer_key,
    customer_city_key,
    payment_date,
    return_date,
    amount,
    rental_duration
from
    dedup_fact_rental
where rnk = 1
order by rental_id;

EOF
)
