Nginx
=====

Auto build nginx and create nginx docker image in debian.

# Usage:
```shell
git clone https://github.com/skygangsta/Dockerfile.git
cd Dockerfile/nginx
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name tomcat1 \
-p 8081:8080 \
-v /home/storage/run/docker/tomcat1/data:/var/data/tomcat \
--cpu-shares=512 --memory=512m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
-d tomcat:8.5-jdk8
```
