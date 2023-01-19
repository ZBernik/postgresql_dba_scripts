#!/bin/bash
#############################################################
#                                                           #
# GET ROLE DDL                                              #
#                                                           #
# @ZBERNARD                                                 #
#                                                           #
#############################################################
#
export PATH=/usr/pgsql-13/bin:$PATH

pg_dumpall --roles-only > roles.lst

#pg_dump --section=pre-data -d aisgamt1 | grep -e '^\(GRANT\|REVOKE\)'  > roles2.lst
pg_dump --section=pre-data -d aisgamt1 > dump.sql; grep -e '^\(GRANT\|REVOKE\)' dump.sql > roles2.lst

#END

 



