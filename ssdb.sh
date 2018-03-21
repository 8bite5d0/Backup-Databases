#!/bin/bash

SSDB_PATH=/usr/local/ssdb/
BACKUP_PATH=/opt/backup/ssdb
DATE=`date +%Y-%m-%d`

for ssdb in `netstat -npa | grep ssdb | grep -v grep | awk '{print $4}' | sort | uniq`; do

ssdb_IP=`echo ${ssdb} | awk -F : '{print $1}'` 
ssdb_PORT=`echo ${ssdb} | awk -F : '{print $2}'`

OUT="${BACKUP_PATH}/${ssdb_PORT}"
echo "BACKUP_PATH $OUT"
if [ ! -d "$OUT" ]; then 
mkdir -p ${OUT}
fi

$SSDB_PATH/ssdb-dump ${ssdb_IP} ${ssdb_PORT} ${OUT}/$DATE
tar -czf $OUT/ssdb_${ssdb_PORT}_$DATE.tar.gz $OUT/$DATE
rm -R $OUT/$DATE
cd $OUT
/usr/bin/find $OUT -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec /bin/rm -r {} \;

done;
