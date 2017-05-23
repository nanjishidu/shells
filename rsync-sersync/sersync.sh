#!/bin/sh
# sersync.sh
# 基于 inotify + rsync
user=liu;
password=123;
if [ "$1" != "" ]; then
    user=${1}
fi
if [ "$2" != "" ]; then
    password=${2}
fi
mkdir -p /opt/tmp
apt-get update
apt-get install -y rsync wget zip
cd /opt/tmp
wget http://qiniushare.gophper.com/inotify-tools-3.14.tar.gz
tar -zxvf inotify-tools-3.14.tar.gz
cd inotify-tools-3.14
./configure --prefix=/usr/local/inotify 
make && make install
cd /opt/tmp
wget http://qiniushare.gophper.com/sersync2.5.4_64bit_binary_stable_final.zip
unzip sersync2.5.4_64bit_binary_stable_final.zip
mv sersync2.5.4_64bit_binary_stable_final /usr/local/sersync
echo "${user}:${password}" >/usr/local/sersync/sersync.pass 
chmod 600  /usr/local/sersync/sersync.pass 

/usr/local/sersync/sersync2 -r -d -o /usr/local/sersync/confxml.xml >/usr/local/sersync/rsync.log 2>&1 


# <?xml version="1.0" encoding="ISO-8859-1"?>
# <head version="2.5">
#  <host hostip="localhost" port="8008"></host>
#  <debug start="true"/>
#  <fileSystem xfs="false"/>
#  <filter start="false">
#  <exclude expression="(.*)\.php"></exclude>
#  <exclude expression="^data/*"></exclude>
#  </filter>
#  <inotify>
#  <delete start="true"/>
#  <createFolder start="true"/>
#  <createFile start="false"/>
#  <closeWrite start="true"/>
#  <moveFrom start="true"/>
#  <moveTo start="true"/>
#  <attrib start="false"/>
#  <modify start="false"/>
#  </inotify>
 
#  <sersync>
#  <localpath watch="/home/"> <!-- 这里填写服务器A要同步的文件夹路径-->
#  <remote ip="8.8.8.8" name="rsync"/> <!-- 这里填写服务器B的IP地址和模块名-->
#  <!--<remote ip="192.168.28.39" name="tongbu"/>-->
#  <!--<remote ip="192.168.28.40" name="tongbu"/>-->
#  </localpath>
#  <rsync>
#  <commonParams params="-artuz"/>
#  <auth start="true" users="rsync" passwordfile="/usr/local/sersync/sersync.pass"/> <!-- rsync+密码文件 这里填写服务器B的认证信息-->
#  <userDefinedPort start="false" port="874"/><!-- port=874 -->
#  <timeout start="false" time="100"/><!-- timeout=100 -->
#  <ssh start="false"/>
#  </rsync>
#  <failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once--><!-- 修改失败日志记录（可选）-->
#  <crontab start="false" schedule="600"><!--600mins-->
#  <crontabfilter start="false">
#  <exclude expression="*.php"></exclude>
#  <exclude expression="info/*"></exclude>
#  </crontabfilter>
#  </crontab>
#  <plugin start="false" name="command"/>
#  </sersync>
 
#  <!-- 下面这些有关于插件你可以忽略了 -->
#  <plugin name="command">
#  <param prefix="/bin/sh" suffix="" ignoreError="true"/> <!--prefix /opt/tongbu/mmm.sh suffix-->
#  <filter start="false">
#  <include expression="(.*)\.php"/>
#  <include expression="(.*)\.sh"/>
#  </filter>
#  </plugin>
 
#  <plugin name="socket">
#  <localpath watch="/home/demo">
#  <deshost ip="210.36.158.xxx" port="8009"/>
#  </localpath>
#  </plugin>
#  <plugin name="refreshCDN">
#  <localpath watch="/data0/htdocs/cdn.markdream.com/site/">
#  <cdninfo domainname="cdn.chinacache.com" port="80" username="xxxx" passwd="xxxx"/>
#  <sendurl base="http://cdn.markdream.com/cms"/>
#  <regexurl regex="false" match="cdn.markdream.com/site([/a-zA-Z0-9]*).cdn.markdream.com/images"/>
#  </localpath>
#  </plugin>
# </head>