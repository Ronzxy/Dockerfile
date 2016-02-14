Gogs
==========

Create gogs docker image in debian.

# 使用方法
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/gogs
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name gogs \
-p 10022:22 \
-p 3000:3000 \
-v /data/run/docker/gogs/data:/data \
-d gogs:0.8.25.0129
```

# 版本升级
在版本升级时需要事先删除数据目录的 templates 文件夹
