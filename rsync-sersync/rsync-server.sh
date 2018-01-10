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
#最大连接数
max connections=36000
#默认为true，修改为no，增加对目录文件软连接的备份
use chroot=no
#定义日志存放位置
log file=/var/log/rsyncd.log
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
#忽略无关错误
ignore errors = yes
#设置rsync服务端文件为读写权限
read only = no
# hosts allow =  192.168.1.1/24 只允许IP 192.168.1.1 ip段进行同步
hosts allow = *
hosts deny = *
#密码认证文件，格式(虚拟用户名:密码）
secrets file=/etc/rsyncd.pass
# 模块名
[htdocs]
# 同步目录
path=/sites/websites
# 描述
comment = html files
EOF
echo "${user}:${password}" > /etc/rsyncd.pass 
chmod 600  /etc/rsyncd.pass
mkdir -p /sites/websites
/etc/init.d/rsync start

# ubuntu 编译安装rsync
# apt-get install -y wget gcc make
# cd /tmp
# wget https://github.com/nanjishidu/shells/raw/master/rsync-sersync/rsync-3.1.2.tar.gz
# tar -zxvf rsync-3.1.2.tar.gz
# cd rsync-3.1.2
# ./configure
# make && make install