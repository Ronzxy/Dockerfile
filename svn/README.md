SVN
==========

Auto build subversion docker image under debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/svn
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name svn \
-p 3690:3690 \
-v /data/run/docker/svn/data:/data \
--restart=always \
-d svn:debian-jessie
```
