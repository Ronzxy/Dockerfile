Nginx
=====

Auto build nginx and create nginx docker image in debian.

# Usage:
```shell
git clone https://github.com/skygangsta/Dockerfile.git
cd Dockerfile/nginx
chmod 755 builder
./builder
```

# 创建容器
```shell
docker run --name postgres_11.5 \
-p 54320:5432 \
-v /home/storage/run/docker/postgres/meta:/var/lib/postgres \
--cpu-shares=512 --memory=1G --memory-swap=-1 \
--oom-kill-disable \
--restart=always \
-itd postgres:11.5
```

## Citus 优化

```sql
-- 建议配置为cpu核数×希望每个物理节点的shard数×物理节点数。
SET citus.shard_count TO 64;
-- 设置shard数据的副本数量
SET citus.shard_replication_factor TO 2;
-- 设置两阶段提交执行DDL
SET citus.shard_replication_factor TO '2pc'
```
