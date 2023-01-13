#!/bin/bash
#############################################################
#                                                           #
# BACKUP POSTGRESQL CONF v04                                #
#                                                           #
# @ZBERNARD                                                 #
#                                                           #
#############################################################
#
BCK_DIR=/backup
BCK_DATE=`date +%d%m%Y"_"%H%M%S`

PGDATA_PREFIX=/postgres/pgsql
PGDATA_SUFFIX=data13
PG_CONF=postgresql.conf
HBA_CONF=pg_hba.conf
#
############################################################################

copy_conf () {
for project in INST1 INST2
do  cp -ip $PGDATA_PREFIX/${project}/$PGDATA_SUFFIX/$PG_CONF $BCK_DIR/${project}_pg_$BCK_DATE.conf
    cp -ip $PGDATA_PREFIX/${project}/$PGDATA_SUFFIX/$HBA_CONF $BCK_DIR/${project}_hba_$BCK_DATE.conf
done
}

###########################################################################

zip_bck () {
tar -czvf $BCK_DIR/conf_$BCK_DATE.tar.gz $BCK_DIR/*.conf --remove-files
}

#############################################################################

clean () {
export PCT_USED=`df -h  $BCK_DIR | sed -e '1d' -e 's/.* .* \(.* \).*/\1/' -e 's/%//'`
if [ $PCT_USED -ge 98 ]; then
find $BCK_DIR/* -ctime +300 -delete;
exit;
fi
}

####################################################################################
# RUN
copy_conf
zip_bck
clean

##############################################################
# UNPACK BACKUP: tar -xzvf conf_$BCK_DATE.tar.gz             #
##############################################################
#END
