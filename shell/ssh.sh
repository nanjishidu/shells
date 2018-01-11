#/bin.sh
# 1. 需要安装 autossh 
# 2. 需要配置ssh免密登陆
autossh -M 5678 -C -N -g -o TCPKeepAlive=yes -o ServerAliveInterval=60 \
-o ServerAliveCountMax=1 -R 8080:127.0.0.1:80  -R 5222:127.0.0.1:22  root@VPSIP -p22 &