PHP
==========

Auto build php in nginx docker container

# Usage:
```shell
# Create Nginx Container
docker run --name YOUR_CONTAINER_NAME \
-p 8801:80 \
-v /data/run/docker/YOUR_CONTAINER_NAME/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /data/run/docker/YOUR_CONTAINER_NAME/conf/conf.d:/etc/nginx/conf.d \
-v /data/run/docker/YOUR_CONTAINER_NAME/logs:/var/log/nginx \
-v /data/run/docker/YOUR_CONTAINER_NAME/keys:/keys \
-v /data/run/docker/YOUR_CONTAINER_NAME/data:/data \
-v /:/ROOT \
-d nginx:NGINX_CONTAINER_VERSION

docker exec -ti YOUR_CONTAINER_NAME bash

git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/php
chmod 755 builder
./builder
```
