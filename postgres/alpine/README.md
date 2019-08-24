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
docker run --name postgres \
    -h postgres \
    -p 54321:5432 \
    -v /home/storage/run/docker/postgres/meta:/var/lib/postgres \
    -e POSTGRES_PASSWORD=123456 \
    --cpu-shares=512 --memory=1G --memory-swap=0 \
    --restart=always \
    --oom-kill-disable \
    -it -d postgres:11.5-alpine
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

# 创建PostGIS空间数据库

CONTAINER_NAME=postgres_master

docker exec -it ${CONTAINER_NAME} createdb -U postgres template_postgis
docker exec -it ${CONTAINER_NAME} psql -U postgres -f /usr/postgres/share/contrib/postgis-2.5/postgis.sql -d template_postgis
docker exec -it ${CONTAINER_NAME} psql -U postgres -f /usr/postgres/share/contrib/postgis-2.5/spatial_ref_sys.sql -d template_postgis


# 创建 PostgreSQL 集群

```shell

docker run --name postgres_master \
    -h postgres-master \
    -p 54321:5432 \
    -v /home/storage/run/docker/postgres/meta/master:/var/lib/postgres \
    -e POSTGRES_PASSWORD=123456 \
    -e SYNC_MODE=SYNC \
    -e NETWORK="172.17.0.0/24" \
    --cpu-shares=512 --memory=2G --memory-swap=0 \
    --restart=always \
    --oom-kill-disable \
    -it -d postgres:11.5-alpine

sleep 5

docker run --name postgres_backup1 \
    -h postgres-backup1 \
    -p 54322:5432 \
    -v /home/storage/run/docker/postgres/meta/backup1:/var/lib/postgres \
    -e PGTYPE="BACKUP" \
    -e PGMASTER_HOST="172.17.0.1" \
    -e PGMASTER_PORT=54321 \
    -e SYNC_MODE=SYNC \
    -e SYNC_NAME="pg_backup1" \
    --cpu-shares=512 --memory=1G --memory-swap=0 \
    --restart=always \
    --oom-kill-disable \
    -it -d postgres:11.5-alpine

docker run --name postgres_backup2 \
    -h postgres-backup2 \
    -p 54323:5432 \
    -v /home/storage/run/docker/postgres/meta/backup2:/var/lib/postgres \
    -e PGTYPE="BACKUP" \
    -e PGMASTER_HOST="172.17.0.1" \
    -e PGMASTER_PORT=54321 \
    -e SYNC_MODE=SYNC \
    -e SYNC_NAME="pg_backup2" \
    --cpu-shares=512 --memory=1G --memory-swap=0 \
    --restart=always \
    --oom-kill-disable \
    -it -d postgres:11.5-alpine

```


