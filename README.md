#shell

##docker

+ redis.sh 使用脚本快速建立主从测试环境

```
./redis clear   //清除以 redis- 命名的容器
./redis 10    	//快速创建以redis-master为主reids和10个以redis-slave为前缀的从redis 
./redis 10 16379//第二个参数指定从redis服务器的起始端口
``` 

+ 使用

```
wget https://raw.githubusercontent.com/nanjishidu/shells/master/docker/redis.sh
chmod +x redis.sh
./redis.sh
```

