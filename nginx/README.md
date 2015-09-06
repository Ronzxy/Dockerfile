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
docker run --name nginx_inst \
-p 80:80 \
-p 443:443 \
-v /docker/nginx_inst/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /docker/nginx_inst/conf/conf.d:/etc/nginx/conf.d \
-v /docker/nginx_inst/logs/:/logs \
-v /docker/nginx_inst/keys/:/keys \
-v /docker/nginx_inst/html/:/html \
-d nginx:1.8.0
```
