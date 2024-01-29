#!/bin/bash

export HOST="localhost"
export DBNAME="dvdrental"
export USER="postgres"

export TARGET_DATE=\'$(date -d '-1 day' '+%Y-%m-%d')\'
#export TARGET_DATE=\'2024-01-28\'

# new customer
source ./sql/elt_new_customer.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "INSERT NEW CUSTOMER: COMPLETE "
echo ""

# update customer
source ./sql/elt_scd_type2_customer.sql
psql -h ${HOST} -d "${DBNAME}" -U ${USER} -c "${SQL}"
echo "UPDATE CUSTOMER: COMPLETE "
echo ""
