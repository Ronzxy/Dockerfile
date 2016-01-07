MongoDB
==========

Create mongodb docker image in debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/mongodb
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name mongodb \
-p 27017:27017 \
-v /data/run/docker/mongodb/data:/var/lib/mongodb:rw \
-v /data/run/docker/mongodb/logs:/var/log/mongodb:rw \
-v /:/ROOT:ro \
-e AUTH=YES \
-d mongodb:debian-wheezy
```
