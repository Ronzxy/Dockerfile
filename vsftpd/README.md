vsftpd
======

Auto build subversion docker image under debian.

# Usage:
```shell
git clone https://openeasy.net/openeasy/dockerfile.git
cd dockerfile/vsftpd
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name vsftpd \
-p 20:20 \
-p 21:21 \
-p 21100-21130:21100-21130 \
-v /data/run/docker/vsftpd/vsftpd:/etc/vsftpd \
-v /data/run/docker/vsftpd/data:/var/ftp \
-v /data/run/docker/vsftpd/logs:/var/log/vsftpd \
-e PASV_ADDRESS=123.56.19.38 \
-e PASV_MIN_PORT=21100 \
-e PASV_MAX_PORT=21130 \
--cpu-shares=256 \
--memory=256m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
-d vsftpd:debian-jessie
```
