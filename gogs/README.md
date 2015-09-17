Gogs
==========

Create gogs docker image in debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/gogs
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name gogs_inst1 \
-p 10022:22 \
-p 3000:3000 \
-v /data/run/docker/gogs_inst1/data:/data \
-d gogs:0.6.9
```
