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
docker run --name nginx \
-p 80:80 \
-p 443:443 \
-p 8017:80 \
-v /home/storage/run/docker/nginx/conf:/etc/nginx \
-v /home/storage/run/docker/nginx/logs:/var/log/nginx \
-v /home/storage/run/docker/nginx/keys:/keys \
-v /home/storage/run/docker/nginx/data:/data \
--cpu-shares=512 --memory=128m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
-d nginx:1.14.2
```
