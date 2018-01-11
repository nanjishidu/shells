#!/bin/sh
#备份目录
rsync -avzD --progress --stats --delete /opt/data/backup /opt/data2