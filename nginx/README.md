Nginx
==========

Auto build nginx and create nginx docker image in debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/nginx
chmod 755 nginx-builder
./nginx-builder
```

# 创建容器
```shell
docker run --name nginx_inst1 \
-p 80:80 \
-p 443:443 \
-v /data/run/docker/nginx_inst1/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /data/run/docker/nginx_inst1/conf/conf.d:/etc/nginx/conf.d \
-v /data/run/docker/nginx_inst1/logs:/var/log/nginx \
-v /data/run/docker/nginx_inst1/keys:/keys \
-v /data/run/docker/nginx_inst1/data:/data \
-d nginx:1.8.0
```
