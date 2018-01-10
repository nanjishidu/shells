#!/bin/sh
# 配置数据同步接收端 安装rsync


#user和password 为rsync同步账号密码，配置要一致
user=nanjishidu;
password=nanjishidu;
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

# ubuntu 编译安装rsync
# apt-get install -y wget gcc make
# cd /tmp
# wget https://github.com/nanjishidu/shells/blob/master/rsync-sersync/rsync-3.1.2.tar.gz
# tar -zxvf rsync-3.1.2.tar.gz
# cd rsync-3.1.2
# ./configure
# make && make install