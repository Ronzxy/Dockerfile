### 下载 rabbitmq 镜像
```sh
docker pull rabbitmq:3.7-management
```

### 配置 DNS
```sh
echo "10.10.21.104 rabbitmq-01 rabbitmq-01.container.cn" >> /etc/hosts
echo "10.10.21.105 rabbitmq-02 rabbitmq-02.container.cn" >> /etc/hosts
```

### 以 host 网络方式启动容器
```sh
docker run -d --hostname rabbitmq-01.container.cn \
    --name rabbitmq \
    --net host \
    --log-opt max-size=10m \
    --log-opt max-file=3 \
    -v /home/storage/run/docker/redis/rabbitmq:/var/lib/rabbitmq:z \
    -e RABBITMQ_DEFAULT_USER=rabbitmq \
    -e RABBITMQ_DEFAULT_PASS=Abc@rabbitmq \
    -e RABBITMQ_ERLANG_COOKIE='Abc@rabbit.cookie' \
    --dns 172.16.1.11 \
    --cpu-shares=1024 --memory=60G --memory-swap=-1 \
    --oom-kill-disable=true \
    --restart=always \
    rabbitmq:3.7-management
```

```sh
docker run -d --hostname rabbitmq-02.container.cn \
    --name rabbitmq \
    --net host \
    --log-opt max-size=10m \
    --log-opt max-file=3 \
    -v /home/storage/run/docker/redis/rabbitmq:/var/lib/rabbitmq:z \
    -e RABBITMQ_DEFAULT_USER=rabbitmq \
    -e RABBITMQ_DEFAULT_PASS=Abc@rabbitmq \
    -e RABBITMQ_ERLANG_COOKIE='Abc@rabbit.cookie' \
    --dns 172.16.1.11 \
    --cpu-shares=1024 --memory=60G --memory-swap=-1 \
    --oom-kill-disable=true \
    --restart=always \
    rabbitmq:3.7-management
```

# 创建集群
docker exec -it rabbitmq rabbitmqctl set_user_tags rabbitmq administrator

# 加入集群
# 在主节点执行
docker exec -it rabbitmq rabbitmqctl -n rabbit@rabbitmq-02 stop_app
docker exec -it rabbitmq rabbitmqctl -n rabbit@rabbitmq-02 join_cluster rabbit@rabbitmq-01
docker exec -it rabbitmq rabbitmqctl -n rabbit@rabbitmq-02 start_app

# 或每个备节点执行
# 以磁盘节点方式加入
docker exec -it rabbitmq rabbitmqctl stop_app
docker exec -it rabbitmq rabbitmqctl join_cluster rabbit@rabbitmq-01
docker exec -it rabbitmq rabbitmqctl start_app

# 以内存节点方式加入
docker exec -it rabbitmq rabbitmqctl stop_app
docker exec -it rabbitmq rabbitmqctl join_cluster --ram rabbit@rabbitmq-01
docker exec -it rabbitmq rabbitmqctl start_app

# 集群状态
docker exec -it rabbitmq rabbitmqctl cluster_status

# 将要移除的故障节点停机
docker exec -it rabbitmq rabbitmqctl stop

# 在一个正常的节点上进行节点的移除.
docker exec -it rabbitmq  rabbitmqctl -n rabbit@rabbitmq-01 forget_cluster_node rabbit@rabbitmq-02

# 添加虚拟主机
docker exec -it rabbitmq rabbitmqctl add_vhost vhostname

# 查看当前所有用户
docker exec -it rabbitmq rabbitmqctl list_users
 
# 查看默认guest用户的权限
docker exec -it rabbitmq rabbitmqctl list_user_permissions guest
 
# 由于RabbitMQ默认的账号用户名和密码都是guest。为了安全起见, 先删掉默认用户
docker exec -it rabbitmq rabbitmqctl delete_user guest
 
# 添加新用户
docker exec -it rabbitmq rabbitmqctl add_user username password
 
# 设置用户tag
docker exec -it rabbitmq rabbitmqctl set_user_tags username administrator
 
# 赋予用户默认vhost的全部操作权限
docker exec -it rabbitmq rabbitmqctl set_permissions -p / username ".*" ".*" ".*"
 
# 查看用户的权限
docker exec -it rabbitmq rabbitmqctl list_user_permissions username

### 集群端口

```conf
4369
#epmd, a peer discovery service used by RabbitMQ nodes and CLI tools
5672, 5671
#used by AMQP 0-9-1 and 1.0 clients without and with TLS
25672
#used for inter-node and CLI tools communication (Erlang distribution server port) and is allocated from a dynamic range (limited to a single port by default, computed as AMQP port + 20000). See networking guide for details.
35672-35682
#used by CLI tools (Erlang distribution client ports) for communication with nodes and is allocated from a dynamic range (computed as Erlang dist port + 10000 through dist port + 10010). See networking guide for details.
15672
#HTTP API clients and rabbitmqadmin (only if the management plugin is enabled)
61613, 61614
#STOMP clients without and with TLS (only if the STOMP plugin is enabled)
1883, 8883
#(MQTT clients without and with TLS, if the MQTT plugin is enabled
15674
#STOMP-over-WebSockets clients (only if the Web STOMP plugin is enabled)
15675
#MQTT-over-WebSockets clients (only if the Web MQTT plugin is enabled)
```
