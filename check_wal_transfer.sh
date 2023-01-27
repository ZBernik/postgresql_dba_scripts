#!/bin/bash
##############################################################
#                                                            #
# CHECK TRANSFER OF WAL TO TSM                               #
#                                                            #
# @ZBER 15122020 v1                                          #
##############################################################

export PATH=/usr/pgsql-14/bin:$PATH
export PGDATA=/postgres/pgsql/...

DATE=`date '+%Y-%m-%d %H:%M:%S'`
L_DATE=`date '+%Y%m'`
LOG=/postgres/logs/checkwalcount_${L_DATE}.log
export SERVERNAME=`hostname`

###############################################################
checkwal () {

L_DATE=`date '+%Y%m'`
#LOG=/postgres/logs/checkwal_${L_DATE}.log
unset failwalcount
export failwalcount=`psql -c "select failed_count from pg_stat_archiver where last_failed_time > NOW() - INTERVAL '20 minutes'" | grep '0 rows' | wc -l`
export FAIL_MSG=`psql -c "select failed_count from pg_stat_archiver where last_failed_time > NOW() - INTERVAL '20 minutes'"`
#
for i in $failwalcount
do
if [ $failwalcount = 1 ]; then
echo "$DATE Failed wal count = 0 - OK"
else echo "$DATE $SERVERNAME - PROD - $FAIL_MSG !!! - NOT OK"
echo "$DATE $SERVERNAME $FAIL_MSG - NOT OK!" | mailx -s "$SERVERNAME - Failed WAL transfer to TSM!" -S smtp=*.*.*.*:25 -r Postgres.Monitor@email.com  db_group@email.com
fi
done
}

#############################################################

checkwal

#END