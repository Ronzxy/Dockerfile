Oracle-XE
==========

Auto build nginx and create nginx docker image in debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/nginx
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name oracle-xe \
-p 1521:1521 \
-p 8080:8080 \
-v /data/run/docker/oracle-xe/oradata:/oradata:rw \
--memory=1024m \
--memory-swap=-1 \
--cpu-shares=512 \
--cpuset-cpus=1 \
--oom-kill-disable=true \
--restart=always \
-i -d oracle:xe-11.2.0
```

连接数据库:
```sh
HOSTNAME: localhost
    Port: 1521
     SID: xe
Username: system
Password: oracle
```

连接到Oracle Application Express Web管理控制台:

```sh
URL: http://localhost:8080/apex/

Workspace：	INTERNAL
 Username：	ADMIN
 Password：  oracle
```
