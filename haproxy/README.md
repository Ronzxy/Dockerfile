HAProxy
==========

Auto build haproxy and create haproxy docker image in debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/haproxy
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name haproxy_inst1 \
-p 13501:13501 \
-v /data/run/docker/haproxy_inst1/conf/haproxy.cfg:/haproxy/conf/haproxy.cfg \
-v /data/run/docker/haproxy_inst1/logs:/var/log/haproxy \
-d haproxy:1.6.1
```
