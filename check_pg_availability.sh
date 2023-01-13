#!/bin/bash
##############################################################
#                                                            #
# CHECK Postgresql AVAILIBILITY                              #
#                                                            #
# @ZBER 05082021                                             #
##############################################################

export PATH=/usr/pgsql-13/bin:$PATH
DATE=`date '+%Y-%m-%d %H:%M:%S'`
L_DATE=`date '+%Y%m'`
LOG=/postgres/logs/checkdb_${L_DATE}.log

export PGDATA=/postgres/pgsql/project1/data13
#export PGDATA2=/postgres/pgsql/project2/data13

SERVERNAME=`hostname`
DBLIST='db1 db2'
export SMTP_IP=type_ip_address
export MAIL=type_your_email

####################################################################################################
checkdb () {

for i in $DBLIST;
do
pg_isready -t 20 -d $i >/dev/null 2>&1
if [ $? = 0 ]; then
echo "$DATE DB $i is available - OK" | tee -a $LOG
else echo "$DATE DB $i is not avalable !!! - NOT OK" | tee -a $LOG
echo "$DATE DB $i is not avalable !!!"  | mailx -s "$SERVERNAME $DATE - DB $i is not available!" -S smtp=${SMTP_IP}:25 -r Postgres.Monitor@mail.cz  $MAIL
fi
done
}

####################################################################################################
checkcluster () {

for PG_DATA in $PGDATA;
do
CHECK_REC=`LANG=C pg_controldata -D $PG_DATA | grep "Database cluster state" | grep "in production" | wc -l`
CHECK_MSG=`LANG=C pg_controldata -D $PG_DATA | grep "Database cluster state"`
if [ $CHECK_REC = 1 ]; then
echo "$DATE $PG_DATA $CHECK_MSG" |  tee -a $LOG
else
MAILLOG=/postgres/logs/mail_$$.log
PGFILE=`ls -td $PG_DATA/log/* | head -1`
echo "$DATE $CHECK_MSG" | tee -a $LOG $MAILLOG
egrep -w 'ERROR|PANIC|FATAL|crash|Killed|terminated|Failed|abnormally|shut down' $PGFILE | egrep -v "pgwatch2" >> $MAILLOG
cat $MAILLOG | mailx -s "$SERVERNAME $DATE -  DB $DBLIST is not avalable! " -S smtp=${SMTP_IP}:25 Postgres.Monitor@mail.cz  $MAIL
fi
done
}

#############################################################################################################

checkdb
checkcluster
#END
