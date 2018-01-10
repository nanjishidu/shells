#!/bin/sh
# 配置数据同步发送端 安装sersync + inotify + rsync
# user和password 为rsync同步账号密码，配置要一致
user=nanjishidu;
password=3ro4FUfqquh8WVn2PxCCCEDY5WFrU1nsGgjznStWKiQ=;
# 同步的模块名 需要一致
module=htdocs;
# 接收服务器ip
remote_ip=192.168.1.2;
# 本地监听目录
local_path=/var/www/htdocs/
if [ "$1" != "" ]; then
    user=${1}
fi
if [ "$2" != "" ]; then
    password=${2}
fi
if [ "$3" != "" ]; then
    module=${3}
fi
if [ "$4" != "" ]; then
    ip=${4}
fi
if [ "$5" != "" ]; then
    local_path=${5}
fi
apt-get update
apt-get install -y rsync wget
cd /tmp
wget https://github.com/nanjishidu/shells/raw/master/rsync-sersync/inotify-tools-3.14.tar.gz
tar -zxvf inotify-tools-3.14.tar.gz
cd inotify-tools-3.14
./configure --prefix=/usr/local/inotify 
make && make install
cd /tmp
wget https://github.com/nanjishidu/shells/raw/master/rsync-sersync/sersync2.5.4_64bit_binary_stable_final.tar.gz
tar -zxvf sersync2.5.4_64bit_binary_stable_final.tar.gz
mv sersync2.5.4_64bit_binary_stable_final /usr/local/sersync
echo "${user}:${password}" >/usr/local/sersync/sersync.pass 
chmod 600  /usr/local/sersync/sersync.pass 
cat>/usr/local/sersync/confxml.xml<<EOF
<?xml version="1.0" encoding="ISO-8859-1"?>
    <head version="2.5">
     <host hostip="localhost" port="8008"></host>
     <debug start="true"/>
     <fileSystem xfs="false"/>
     <filter start="false">
     <exclude expression="(.*)\.php"></exclude>
     <exclude expression="^data/*"></exclude>
     </filter>
     <inotify>
     <delete start="true"/>
     <createFolder start="true"/>
     <createFile start="false"/>
     <closeWrite start="true"/>
     <moveFrom start="true"/>
     <moveTo start="true"/>
     <attrib start="false"/>
     <modify start="false"/>
     </inotify>
 
     <sersync>
     <localpath watch="${local_path}"> <!-- 这里填写服务器A要同步的文件夹路径-->
     <remote ip="${remote_ip}" name="${module}"/> <!-- 这里填写服务器B的IP地址和模块名-->
     <!--<remote ip="192.168.1.3" name="htdocs"/>--> <!-- 这里填写服务器C的IP地址和模块名-->
     </localpath>
     <rsync>
     <commonParams params="-artuz"/>
     <auth start="true" users="${user}" passwordfile="/usr/local/sersync/sersync.pass"/> <!-- rsync+密码文件 这里填写服务器B的认证信息-->
     <userDefinedPort start="false" port="874"/><!-- port=874 -->
     <timeout start="false" time="100"/><!-- timeout=100 -->
     <ssh start="false"/>
     </rsync>
     <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once--><!-- 修改失败日志记录（可选）-->
     <crontab start="false" schedule="600"><!--600mins-->
     <crontabfilter start="false">
     <exclude expression="*.php"></exclude>
     <exclude expression="info/*"></exclude>
     </crontabfilter>
     </crontab>
     <plugin start="false" name="command"/>
     </sersync>
 
     <!-- 下面这些有关于插件你可以忽略了 -->
     <plugin name="command">
     <param prefix="/bin/sh" suffix="" ignoreError="true"/> <!--prefix /opt/tongbu/mmm.sh suffix-->
     <filter start="false">
     <include expression="(.*)\.php"/>
     <include expression="(.*)\.sh"/>
     </filter>
     </plugin>
 
     <plugin name="socket">
     <localpath watch="/home/demo">
     <deshost ip="210.36.158.xxx" port="8009"/>
     </localpath>
     </plugin>
     <plugin name="refreshCDN">
     <localpath watch="/data0/htdocs/cdn.markdream.com/site/">
     <cdninfo domainname="cdn.chinacache.com" port="80" username="xxxx" passwd="xxxx"/>
     <sendurl base="http://cdn.markdream.com/cms"/>
     <regexurl regex="false" match="cdn.markdream.com/site([/a-zA-Z0-9]*).cdn.markdream.com/images"/>
     </localpath>
     </plugin>
    </head>
EOF
# /usr/local/sersync/sersync2 -r -d -o /usr/local/sersync/confxml.xml >/usr/local/sersync/rsync.log 2>&1 