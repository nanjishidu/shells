#/bin/sh
#自用服务监听脚本
#ssh=`ps awx|grep "autossh"|grep -v grep`
#if [ "$ssh" = "" ];then
#        echo "`date '+%Y-%m-%d %H:%M:%S'` ssh is not exist,running..."
#     /opt/bin/sshd.sh &
#fi
#rslsync=`ps awx|grep "rslsync"|grep -v grep`
#if [ "$rslsync" = "" ];then
#        echo "`date '+%Y-%m-%d %H:%M:%S'` rslsync is not exist,running..."
#	 cd /opt/bin
#       /opt/bin/rslsync --config /opt/bin/rslsync.conf &
#fi
frpc=`ps awx|grep "frpc"|grep -v grep`
if [ "$frpc" = "" ];then
	echo "`date '+%Y-%m-%d %H:%M:%S'` frpc  is not exist,running..."
	 /opt/bin/frp/frpc -c /opt/bin/frp/frpc.ini &
fi
caddy=`ps awx|grep "caddy"|grep -v grep`
if [ "$caddy" = "" ];then
        echo "`date '+%Y-%m-%d %H:%M:%S'` caddy  is not exist,running..."
	cd /opt/bin/caddy
	/opt/bin/caddy/caddy  -conf /opt/bin/caddy/Caddyfile  &
fi
gitea=`ps awx|grep "gitea"|grep -v grep`
if [ "$gitea" = "" ];then
        echo "`date '+%Y-%m-%d %H:%M:%S'` gitea  is not exist,running..."
	export USER=git
        cd  /opt/data/gitea
        /opt/data/gitea/gitea web -c /opt/data/gitea/custom/conf/app.ini  &
fi