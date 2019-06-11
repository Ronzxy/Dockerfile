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
docker run --name svn-backup-unison-2201 \
-p 2201:22 \
-v /home/storage/run/docker/svn-backup-unison-2201/data:/data \
--cpu-shares=256 --memory=512m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
-d unison:debian-jessie
```
