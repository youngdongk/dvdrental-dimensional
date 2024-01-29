#!/bin/bash

export HOST="localhost"
export DBNAME="dvdrental"
export USER="postgres"

# create tables
source ./sql/create_dimensional.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "CREATE TABLES: COMPLETE "
echo ""

# insert dim_customer
source ./sql/dim_customer.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "LOAD dim_customer: COMPLETE "
echo ""

# insert dim_city
source ./sql/dim_city.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "LOAD dim_city: COMPLETE "
echo ""

# insert dim_date
source ./sql/dim_date.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "LOAD dim_date: COMPLETE "
echo ""

# insert dim_film
source ./sql/dim_film.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "LOAD dim_film: COMPLETE "
echo ""

# insert dim_store
source ./sql/dim_store.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "LOAD dim_store: COMPLETE "
echo ""

# insert fact_rental
source ./sql/fact_rental.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "LOAD fact_rental: COMPLETE "
echo ""

