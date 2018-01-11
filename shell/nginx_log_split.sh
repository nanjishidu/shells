#!/bin/sh
destdate=`/bin/date -d '-15 minutes' +%Y%m`
destday=`/bin/date -d '-15 minutes' +%d`
for i in log.gophper.com app.gophper.com kpass.gophper.com
do
destdir="/opt/logs/${i}/${destdate}"
srclog="/opt/logs/${i}/access.log"
destlog="/opt/logs/${i}/${destdate}/access${destday}.log"
if [ ! -d ${destdir} ]; then
    mkdir -p ${destdir}
fi
mv  ${srclog} ${destlog}
touch ${srclog}
done
systemctl restart nginx