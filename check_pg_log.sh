#!/bin/bash
##############################################################
# Show errors from Postgresql logfile                        #
#                                                            #
#                                                            #
#                                                            #
# @ZBER 16032021                                             #
##############################################################


export PGDATA=/postgres/pgsql/project_name/data13
PGLOG=$PGDATA/log/

list () {
egrep -w 'ERROR|PANIC|FATAL|crash|Killed|terminated|Failed|abnormally' $PGLOG$i
}


usage () {
cat << EOF
Usage: check_pg_log.sh [-t|-1|-2|-3|-4|-5|-6|-7|-h]

pgerr - without parameter command lists errors from actual day

-t the whole week 1-7
-1 monday
-2 tuesday
-3 wednesday
-4 thursday
-5 friday
-6 saturday
-7 sunday
-h help
EOF
exit 0
}


pgerr()
{
pgfile=`ls -td $PGLOG/* | head -1`;egrep -w 'ERROR|PANIC|FATAL|crash|Killed|terminated|Failed|abnormally' $pgfile
}


pgerr_week () {
for i in postgresql-Sat.log postgresql-Sun.log postgresql-Mon.log postgresql-Tue.log postgresql-Wed.log postgresql-Thu.log postgresql-Fri.log
do
list
done
}


pgerr_mon () {
for i in postgresql-Mon.log
do
list
done
}

pgerr_tue () {
for i in postgresql-Tue.log
do
list
done
}


pgerr_wed () {
for i in postgresql-Wed.log
do
list
done
}

pgerr_thu () {
for i in postgresql-Thu.log
do
list
done
}

pgerr_fri () {
for i in postgresql-Fri.log
do
list
done
}

pgerr_sat () {
for i in postgresql-Sat.log
do
list
done
}

pgerr_sun () {
for i in postgresql-Sun.log
do
list
done
}


if [[ $1 == "" ]]; then
   pgerr;
    exit 10;
else
while getopts 't1234567h' flag
do
  case $flag in
    t) pgerr_week ;;
    1) pgerr_mon ;;
    2) pgerr_tue ;;
    3) pgerr_wed ;;
    4) pgerr_thu ;;
    5) pgerr_fri ;;
    6) pgerr_sat ;;
    7) pgerr_sun ;;
    h|*) usage ;;
   esac
done
fi

#END