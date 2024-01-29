SQL=$(cat <<EOF

-- date_gen
with recursive init(i) AS (
  select 1
  union all
  select i + 1 
  from init 
  where (i + 1) <= 7305
),
date_gen as (
  select to_date('2024-12-31', 'YYYY-MM-DD') - interval '7305days' + interval '1 day' * i as dates
  from init
), 
tmp_dim_date as (
select dates as "date", 
extract(day from dates) as "day",
extract(month from dates) as "month",
extract(year from dates) as "year",
case 
  when extract(dow from dates) = 0 then 'Sunday'
  when extract(dow from dates) = 1 then 'Monday'
  when extract(dow from dates) = 2 then 'Tuesday'
  when extract(dow from dates) = 3 then 'Wednesday'
  when extract(dow from dates) = 4 then 'Thursday'
  when extract(dow from dates) = 5 then 'Friday'
  when extract(dow from dates) = 6 then 'Saturday'
end as day_of_week,
case
  when extract(month from dates) < 4 then extract(year from dates + (interval '-1' year)) 
  else extract(year from dates)
end as fiscal_year,
case
  when extract(month from dates) < 4 then extract(year from dates + (interval '-1' year)) || '年度'
  else extract(year from dates) || '年度'
end as fiscal_year_label,
case
  when extract(month from dates) < 4 then extract(month from dates) + 9
  else extract(month from dates) - 3
end as fiscal_month_num,
extract(week from dates) as week_num
from date_gen
order by "date"
)
-- insert
INSERT INTO public.dim_date
("date", "day", "month", "year", day_of_week, fiscal_year, fiscal_year_label, fiscal_month_num, week_num)
select * from tmp_dim_date;

EOF
)
