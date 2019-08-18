## 创建 redis 容器
docker run --name redis \
    -p 6379:6379 \
    -v /home/storage/run/docker/redis:/var/lib/redis:rw \
    --cpu-shares=512 --memory=512m --memory-swap=-1 \
    --oom-kill-disable=true \
    --restart=always \
    -t -i -d redis:5.0.5


## 创建集群

### 开放端口
firewall-cmd --zone=public --add-port=6379/tcp --permanent
firewall-cmd --zone=public --add-port=16379/tcp --permanent
firewall-cmd --zone=public --add-port=6380/tcp --permanent
firewall-cmd --zone=public --add-port=16380/tcp --permanent
firewall-cmd --reload
firewall-cmd --query-port=6379/tcp
firewall-cmd --query-port=16379/tcp
firewall-cmd --query-port=6380/tcp
firewall-cmd --query-port=16380/tcp

### 系统优化
echo 1 > /proc/sys/vm/overcommit_memory
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 512 > /proc/sys/net/core/somaxconn

docker run --name redis \
    --net host \
    -v /home/storage/run/docker/redis:/var/lib/redis:rw \
    -e CLUSTER_ENABLE=yes \
    -e REDIS_PORT=6379 \
    --cpu-shares=1024 --memory=45G --memory-swap=-1 \
    --oom-kill-disable=true \
    --restart=always \
    -t -i -d redis:5.0.5

docker run --name redis_backup \
    --net host \
    -v /home/storage/run/docker/redis_backup:/var/lib/redis:rw \
    -e CLUSTER_ENABLE=yes \
    -e REDIS_PORT=6380 \
    --cpu-shares=512 --memory=45G --memory-swap=-1 \
    --oom-kill-disable=true \
    --restart=always \
    -t -i -d redis:5.0.5

### --replicas 1  表示自动为每一个master节点分配一个slave节点
redis-cli --cluster create 10.10.21.101:6379 10.10.21.102:6379 10.10.21.103:6379 \
    10.10.21.101:6380 10.10.21.102:6380 10.10.21.103:6380 \
    --cluster-replicas 1

### 将节点连接到工作集群
redis-cli -c -h 10.10.21.101 CLUSTER MEET 10.10.21.101 6379
### 查看集群所有节点
redis-cli -c -h 10.10.21.101 CLUSTER NODES
### 查看集群节点信息
redis-cli -c -h 10.10.21.101 CLUSTER INFO
### 通过任意节点检查集群状态
redis-cli --cluster check 10.10.21.101:6379
### 通过任意节点修复集群状态
redis-cli --cluster fix 10.10.21.102:6379
### 新增一个主节点
redis-cli --cluster add-node host:port 10.10.21.101:6379
### 新增一个主节点的从节点
redis-cli --cluster add-node host:port 10.10.21.101:6379 --cluster-slave --cluster-master-id {master_id}
### 迁移数据
redis-cli --cluster reshard host:port
### 删除节点
redis-cli --cluster del-node host:port node_id

### 设置集群访问密码
redis-cli --cluster config set masterauth passwd123 
redis-cli --cluster config set requirepass passwd123 
redis-cli --cluster config rewrite 

### 安全配置

```conf
# 设置 redis 访问密码
requirepass xxx
# 设置集群节点间访问密码，跟上面一致
masterauth xxx
```

### 参考配置

```conf
bind 0.0.0.0
protected-mode yes
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile /var/run/redis_6379.pid
loglevel notice
logfile /var/log/redis_6379.log
databases 16
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /var/lib/redis/6379
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
maxmemory 2gb
#这里强烈建议关闭aof
#appendonly yes
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
cluster-enabled yes
cluster-config-file nodes-6379.conf
cluster-node-timeout 5000
cluster-slave-validity-factor 0
cluster-migration-barrier 1
cluster-require-full-coverage no
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
```
