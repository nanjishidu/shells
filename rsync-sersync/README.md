# sersync + inotity + rsync 实现数据实时同步

## 1.前言

定时数据同步，可以使用rsync+crontab，但是定时任务的同步时间粒度并不能达到实时同步的要求。

Linux kernel 2.6.13以后提供了inotify文件系统监控机制。通过rsync+inotify组合可以实现实时同步。

sersync是基于前两者开发的工具，不仅保留了优点同时还强化了实时监控，文件过滤，简化配置等功能，帮助用户提高运行效率，节省时间和网络资源。

## 2.使用

* 环境
	* ubuntu
* 示例服务器
	* A 192.168.1.2
	* B 192.168.1.3
	* C 192.168.1.4
	* D 192.168.1.5
### 2.1.配置单模块单服务器同步
#### 2.1.1.在A服务器执行
```
# user和password 为rsync同步账号密码，配置要一致
# 用户名和密码:为rsync同步账号密码，配置要一致
# 模块名:同步的模块名需要一致
# ip:接收服务器ip
# 路径:本地监听目录
# ./sersync.sh 用户名 密码  模块名  ip 路径
# 如果不填使用默认配置
# ./sersync.sh nanjishidu 3ro4FUfqquh8WVn2PxCCCEDY5WFrU1nsGgjznStWKiQ=  htdocs  192.168.1.3 /var/www/htdocs  
wget https://raw.githubusercontent.com/nanjishidu/shells/master/rsync-sersync/sersync.sh
chmod +x sersync.sh
./sersync.sh
```
#### 2.1.2.在B服务器执行
```
# 用户名和密码:为rsync同步账号密码，配置要一致
# 模块名:同步的模块名需要一致
# 路径:同步文件存放目录
# 描述:同步文件描述
# ./rsync.sh 用户名 密码  模块名  路径  描述
# 如果不填使用默认配置
# ./rsync.sh nanjishidu 3ro4FUfqquh8WVn2PxCCCEDY5WFrU1nsGgjznStWKiQ=  htdocs  /var/www/htdocs  "synchronize files"
wget https://raw.githubusercontent.com/nanjishidu/shells/master/rsync-sersync/rsync.sh
chmod +x rsync.sh
./rsync.sh
```

### 2.2.配置多服务器同步

* 在C和D 执行和B服务器相同命令
* 修改主服务器 /usr/local/sersync/confxml.xml 配置，实现A的数据实时同步到B C D。
```
<localpath watch="/var/www/htdocs/">
    <remote ip="192.168.1.3" name="htdocs"/>
    <!--填写需要追加的服务器-->
    <remote ip="192.168.1.4" name="htdocs"/>
    <remote ip="192.168.1.5" name="htdocs"/>
</localpath>
```

### 2.3.配置多模块同步

如果需要配置多个模块拷贝多份主服务器 /usr/local/sersync/confxml.xml修改启动多个实例，每个实例只能监听一个目录
