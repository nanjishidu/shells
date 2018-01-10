#!/bin/sh
# 配置数据同步发送端 安装sersync + inotify + rsync
# user和password 为rsync同步账号密码，配置要一致
user=nanjishidu;
password=nanjishidu;
if [ "$1" != "" ]; then
    user=${1}
fi
if [ "$2" != "" ]; then
    password=${2}
fi
apt-get update
apt-get install -y rsync wget zip
cd /tmp
wget https://github.com/nanjishidu/shells/blob/master/rsync-sersync/inotify-tools-3.14.tar.gz
tar -zxvf inotify-tools-3.14.tar.gz
cd inotify-tools-3.14
./configure --prefix=/usr/local/inotify 
make && make install
cd ../
wget https://github.com/nanjishidu/shells/blob/master/rsync-sersync/sersync2.5.4_64bit_binary_stable_final.tar.gz
tar -zxvf sersync2.5.4_64bit_binary_stable_final.zip
mv sersync2.5.4_64bit_binary_stable_final /usr/local/sersync
echo "${user}:${password}" >/usr/local/sersync/sersync.pass 
chmod 600  /usr/local/sersync/sersync.pass 

/usr/local/sersync/sersync2 -r -d -o /usr/local/sersync/confxml.xml >/usr/local/sersync/rsync.log 2>&1 