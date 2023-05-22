#!/bin/bash
#############################################################
#                                                           #
# COPY SCHEMA                                               #
#                                                           #
# @ZBERNARD                                                 #
#                                                           #
#############################################################

export PGDATA=/postgres/pgsql/project_name/data/14

pg_dump -d zdenek1 --schema='public' | sed 's/public/new_schema/g' | psql -d zdenek1