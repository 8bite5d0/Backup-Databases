#!/bin/bash

BACKUP_PATH=/opt/backup/mongo
DATE=`date +%Y-%m-%d`
MONGODB_PATH=/usr
exclude="28017"

export LC_ALL=C

for mongo in `netstat -npa | grep mongo | grep -v grep | grep tcp | grep -Ev ${exclude} | awk '{print $4}' | sort | uniq`; do

mongo_IP=`echo ${mongo} | awk -F : '{print $1}'` 
mongo_PORT=`echo ${mongo} | awk -F : '{print $2}'`

OUT="${BACKUP_PATH}/${mongo_PORT}"
echo "BACKUP_PATH $OUT"
if [ ! -d "$OUT" ]; then 
mkdir -p ${OUT}
fi

$MONGODB_PATH/bin/mongodump --host $mongo_IP --port $mongo_PORT --out $OUT/$DATE
tar -czf $OUT/mongo_${mongo_PORT}_$DATE.tar.gz $OUT/$DATE
rm -R $OUT/$DATE
cd $OUT
/usr/bin/find $OUT -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec /bin/rm -r {} \;

done;
