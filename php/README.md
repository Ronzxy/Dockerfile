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
docker run --name php \
-p 8088:80 \
-p 4438:443 \
-v /home/storage/run/docker/php/nginx/conf:/etc/nginx \
-v /home/storage/run/docker/php/nginx/logs:/var/log/nginx \
-v /home/storage/run/docker/php/nginx/keys:/keys \
-v /home/storage/run/docker/php/conf:/etc/php \
-v /home/storage/run/docker/php/html:/home/www/html \
--cpu-shares=512 --memory=512m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
-d php-nginx:7.3.2-1.15.9
```
