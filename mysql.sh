#!/bin/bash
myuser=root
mypass=pass
alldb=$(echo "show databases;" | mysql -u$myuser -p$mypass | sed '/performance_schema/d; /Database/d; /information_schema/d; /mysql/d' | tr "\n" " ")
dat=$(date +%d%h%Y)
datlog=$(date +%d_%m_%Y_%H:%M:%S)
logfile=~/dump.$dat.log
 
echo "### BEGIN DUMP BASES ###"> $logfile
echo "$alldb" >> $logfile
echo  >> $logfile
 
echo "FLUSH TABLES WITH READ LOCK;" | mysql -u$myuser -p$mypass
echo "SET GLOBAL read_only = ON;" | mysql -u$myuser -p$mypass
echo "show master status;" | mysql -u$myuser -p$mypass >> $logfile
echo  >> $logfile
 
for base in $alldb
do
    echo "$(date +%d_%m_%Y_%H:%M:%S) begin dump base $base" >> $logfile
    mysqldump -u$myuser -p$mypass --databases $base > ~/${base}.sql 2>> $logfile
    echo "$(date +%d_%m_%Y_%H:%M:%S) end dump base $base" >> $logfile
    echo >> $logfile
done
 
echo "SET GLOBAL read_only = OFF;" | mysql -u$myuser -p$mypass
echo "UNLOCK TABLES;" | mysql -u$myuser -p$mypass
 
tar -caf ${dat}.db.tar.gz ~/*.sql $logfile
rm ~/*.sql $logfile
