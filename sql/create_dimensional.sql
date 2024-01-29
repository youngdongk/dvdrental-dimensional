SQL=$(cat <<EOF

CREATE TABLE dim_city
(
  city_key    serial            NOT NULL,
  city_id     int         NOT NULL,
  city        varchar(50),
  country     varchar(50),
  create_date date       ,
  expire_date date       ,
  PRIMARY KEY (city_key)
);

CREATE TABLE dim_customer
(
  customer_key serial            NOT NULL,
  customer_id  int         NOT NULL,
  first_name   varchar(45),
  last_name    varchar(45),
  full_name    varchar(90),
  email        varchar(50),
  create_date  date       ,
  expire_date  date       ,
  PRIMARY KEY (customer_key)
);

CREATE TABLE dim_date
(
  date              date        NOT NULL,
  day               int        ,
  month             int        ,
  year              int        ,
  day_of_week       varchar(10), 
  fiscal_year       varchar(10),
  fiscal_year_label varchar(10),
  fiscal_month_num  int        ,
  week_num          int        ,
  PRIMARY KEY (date)
);

CREATE TABLE dim_film
(
  film_key     serial         NOT NULL,
  film_id      int         NOT NULL,
  title        varchar     NOT NULL,
  category     varchar(25),
  release_year int       ,
  rating       varchar(20),
  length       int        ,
  length_label varchar(10),
  create_date  date       ,
  expire_date  date       ,
  PRIMARY KEY (film_key)
);

CREATE TABLE dim_store
(
  store_key   serial  NOT NULL,
  store_id    int  NOT NULL,
  create_date date,
  expire_date date,
  PRIMARY KEY (store_key)
);

CREATE TABLE fact_rental
(
  rental_id         int          NOT NULL,
  store_key         int          NOT NULL,
  rental_date       date         NOT NULL,
  store_city_key    int          NOT NULL,
  film_key          int          NOT NULL,
  customer_key      int          NOT NULL,
  customer_city_key int          NOT NULL,
  payment_date      date        ,
  return_date       date        ,
  amount            numeric(5,2),
  rental_duration   int         ,
  PRIMARY KEY (rental_id)
);

EOF
)
