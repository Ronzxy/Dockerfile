PHP
==========

Auto build php docker image in debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/nginx
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name php \
-p 80:80 \
-p 443:443 \
-v /data/run/docker/php/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /data/run/docker/php/conf/conf.d:/etc/nginx/conf.d \
-v /data/run/docker/php/logs:/var/log/nginx \
-v /data/run/docker/php/keys:/keys \
-v /data/run/docker/php/data:/data \
-d php:7.0.6
```
