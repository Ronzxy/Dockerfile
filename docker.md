Docker Official
====

docker 官方映像使用及配置

# 运行容器 #

## 安装Docker ##
```sh
curl -sSL https://get.docker.com | sh
```

## PostgreSQL ##
*运行PostgreSQL容器*:
```sh
# 获取映像
docker pull library/postgres:9.4.5
# 创建并启动
docker run --name postgres_inst1 \
-p 5432:5432 \
-v /data/run/docker/postgres_inst1/data:/var/lib/postgresql/data:rw \
-e POSTGRES_PASSWORD=123456 -d postgres:9.4.5
```

## Percona(MySQL) ##
*运行Percona(MySQL)容器*:
```sh
# 获取映像
docker pull library/percona:5.6.26
# 创建并启动
docker run --name percona_inst1 \
-p 3306:3306 \
-v /data/run/docker/percona_inst1/data:/var/lib/mysql:rw \
-e MYSQL_ROOT_PASSWORD=123456 -d percona:5.6.26
```

## Tomcat ##
*运行Tomcat容器*:
```sh
# 获取映像
docker pull library/tomcat:8-jre8
# 创建并启动
docker run --name tomcat8_inst1 \
-p 8080:8080 \
-v /data/run/docker/tomcat8_inst1/conf/server.xml:/usr/local/tomcat/conf/server.xml \
-v /data/run/docker/tomcat8_inst1/webapps:/usr/local/tomcat/webapps:rw \
-d tomcat:8-jre8
```

*Tomcat主机配置*
```sh
<Engine name="Catalina">
      <Host name="openeasy.net" appBase="webapps" autodeploy="true" unpackWARs="true">
        <Context path="" docBase="openeasy"  debug="0" reloadable="true" />
      </Host>

</Engine>
```

*Tomcat设置JAVA参数*
```sh
JAVA_OPTS="-server  -Dfile.encoding=UTF-8 -Duser.timezone=GMT+08 -Xss2m -Xms1024m -Xmx1024m"
```

## Redis ##
*运行Redis容器*:
```sh
# 获取映像
docker pull redis:3.0.5
# 创建并启动
docker run --name redis_inst1 \
-p 6379:6379 \
-v /data/run/docker/redis_inst1/data:/data:rw \
-d redis:3.0.3 redis-server --appendonly yes
```


# 高级配置 #

## 限制CPU ##
```sh
--cpu-shares=512   # CPU配额，默认最大值1024。简称 -c
--cpuset-cpus=0,1  # 指定使用的CPU核心编号，1.6及以下版本是--cpuset
```

## 限制内存 ##
限制内存后超出使用限制会OOMKilled进程
```sh
--memory=100m      # 限制内存(mem+swap) -m
--memory-swap=-1   # 限制swap+内存，关闭swap为-1
```

## 关闭OOMKilled ##
```sh
--oom-kill-disable=true
```

## 自动重启 ##
```sh
#   使用在 Docker run 的时候使用 --restart 参数来设置。
#   
#   no          - container不重启
#   on-failure  - container推出状态非0时重启
#   always      - 始终重启
#
# https://docs.docker.com/reference/commandline/cli/#restart-policies

--restart=always
```

## 网络模式 ##
```sh
--net=bridge、host、container、none
```

## 设置DNS ##
```sh
--dns=8.8.8.8
--dns=4.4.4.4
```



# 疑难问题 #

## 内存限制无效 ##
```sh
#   On systems using GRUB (which is the default for Ubuntu), 
#   you can add those parameters by editing /etc/default/grub 
#   and extending GRUB_CMDLINE_LINUX. Look for the following line:
#   
#   $ GRUB_CMDLINE_LINUX=""
#   And replace it by the following one:
#   
#   $ GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
#   Then run sudo update-grub, and reboot.
#   
#   These parameters will help you get rid of the following warnings:
#   
#   WARNING: Your kernel does not support cgroup swap limit.
#   WARNING: Your kernel does not support swap limit capabilities. Limitation discarded.


vim /etc/default/grub
# GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
sudo update-grub
reboot
```
