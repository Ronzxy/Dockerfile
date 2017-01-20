Gogs
==========

Create gogs docker image in debian.

# 使用方法
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/unison
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name unison-server-2201 \
-p 2201:22 \
-v /data/run/docker/unison-server-2201/data:/data \
-v /data/run/docker/unison-server-2201/ssh:/root/.ssh \
-d unison:debian-jessie
```
