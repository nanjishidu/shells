# redis-cluster-install.sh
#!/bin/sh
# cluster 部署路径
cluster_path="/opt/modules/redis-cluster";
if [ "$1" != "" ]; then
    cluster_path=${1}
fi
# cluster ip地址
cluster_ip=127.0.0.1;
if [ "$2" != "" ]; then
    cluster_ip=${2}
fi
# 起始端口
cluster_port=7001;
if [ "$3" != "" ]; then
    cluster_port=${3}
fi
# redis-cluster数量
cluster_num=3;
if [ "$4" != "" ]; then
    cluster_num=${4}
fi
# redis-password数量
cluster_password=123456;
if [ "$5" != "" ]; then
    cluster_password=${5}
fi

if [ ! -d ${cluster_path} ]; then
	mkdir -p ${cluster_path}
fi
yum -y update && yum -y install gcc gcc-c++ kernel-devel make wget vim
wget -c https://download.redis.io/releases/redis-6.2.3.tar.gz -O ${cluster_path}/redis-6.2.3.tar.gz
tar -zxvf ${cluster_path}/redis-6.2.3.tar.gz -C ${cluster_path}
cd ${cluster_path}/redis-6.2.3 && make && make install PREFIX=${cluster_path}
chmod -R +x ${cluster_path}/bin

echo "-------------------------------------------------------------------------------------------"


recli_str=""
# 配置文件生成
for ((i=0;i<${cluster_num};i++));
do
    mkdir -p ${cluster_path}/${cluster_port}/conf
    mkdir -p ${cluster_path}/${cluster_port}/data
    cat>${cluster_path}/${cluster_port}/conf/redis.conf<<EOF
# redis端口
port ${cluster_port}
#redis 访问密码
requirepass ${cluster_password}
#redis 访问Master节点密码
masterauth ${cluster_password}
# 关闭保护模式
protected-mode no
# 开启集群
cluster-enabled yes
# 集群节点配置
cluster-config-file ${cluster_path}/${cluster_port}/data/nodes.conf
# 超时
cluster-node-timeout 5000
# 
cluster-require-full-coverage no
# 集群节点IP host模式为宿主机IP
cluster-announce-ip ${cluster_ip}
# 集群节点端口 7001 - 7006
cluster-announce-port ${cluster_port}
cluster-announce-bus-port 1${cluster_port}
# 开启 appendonly 备份模式
appendonly yes
# 每秒钟备份
appendfsync everysec
# 对aof文件进行压缩时，是否执行同步操作
no-appendfsync-on-rewrite no
# 当目前aof文件大小超过上一次重写时的aof文件大小的100%时会再次进行重写
auto-aof-rewrite-percentage 100
# 重写前AOF文件的大小最小值 默认 64mb
auto-aof-rewrite-min-size 64mb
# 日志配置
# debug:会打印生成大量信息，适用于开发/测试阶段
# verbose:包含很多不太有用的信息，但是不像debug级别那么混乱
# notice:适度冗长，适用于生产环境
# warning:仅记录非常重要、关键的警告消息
loglevel notice
# 日志文件路径
logfile ${cluster_path}/${cluster_port}/data/redis.log
EOF
    echo "${cluster_path}/bin/redis-server ${cluster_path}/${cluster_port}/conf/redis.conf"
    recli_str="${recli_str} ${cluster_ip}:${cluster_port}"
	let cluster_port++
done

echo "${cluster_path}/bin/redis-cli -p 7001 -a 123456 --cluster create ${recli_str}"
