#!/bin/sh
#ubuntu 开启服务端
#rsync一般是server到client sersync一般是client到server，sersync可以做到实时监控
# apt-get install -y wget gcc make
# mkdir -p /opt/tmp
# cd /opt/tmp
# wget http://qiniushare.gophper.com/rsync-3.1.2.tar.gz
# tar -zxvf rsync-3.1.2.tar.gz
# cd rsync-3.1.2
# ./configure
# make && make install
user=liu;
password=123;
if [ "$1" != "" ]; then
    user=${1}
fi
if [ "$2" != "" ]; then
    password=${2}
fi
apt-get update
apt-get install -y rsync
sed -i  "s#RSYNC_ENABLE=false#RSYNC_ENABLE=true#g" /etc/default/rsync
cat>/etc/rsyncd.conf<<EOF
uid=root
gid=root
log file=/var/log/rsyncd.log
max connections=36000
use chroot=no
log file=/var/log/rsyncd.log
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
[htdocs1]
path=/sites/websites
comment = video files
ignore errors = yes
read only = no
hosts allow = *
hosts deny = *
secrets file=/etc/rsyncd.pass
EOF
echo "${user}:${password}" > /etc/rsyncd.pass 
chmod 600  /etc/rsyncd.pass
mkdir -p /sites/websites
/etc/init.d/rsync start
# rsync-server.sh