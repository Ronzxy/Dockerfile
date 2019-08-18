alias docker=podman

mkdir -p /home/storage/run/docker/glusterfs/{conf,data,meta,logs}
podman run --privileged=true --name glusterfs \
    --hostname glusterfs-01.container.cn \
    --net host \
    -v /home/storage/run/docker/glusterfs/data:/bricks:z \
    -v /home/storage/run/docker/glusterfs/conf:/etc/glusterfs:z \
    -v /home/storage/run/docker/glusterfs/meta:/var/lib/glusterd:z \
    -v /home/storage/run/docker/glusterfs/logs:/var/log/glusterfs:z \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v /dev:/dev \
    --cpu-shares 512 --memory 8g --memory-swap 0 \
    -it -d glusterfs:6.4


mkdir -p /home/storage/run/docker/glusterfs/{conf,data,meta,logs}
podman run --privileged=true --name glusterfs \
    --hostname glusterfs-02.container.cn \
    --net host \
    -v /home/storage/run/docker/glusterfs/data:/bricks:z \
    -v /home/storage/run/docker/glusterfs/conf:/etc/glusterfs:z \
    -v /home/storage/run/docker/glusterfs/meta:/var/lib/glusterd:z \
    -v /home/storage/run/docker/glusterfs/logs:/var/log/glusterfs:z \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v /dev:/dev \
    --cpu-shares 512 --memory 8g --memory-swap 0 \
    -it -d glusterfs:6.4


mkdir -p /home/storage/run/docker/glusterfs/{conf,data,meta,logs}
podman run --privileged=true --name glusterfs \
    --hostname glusterfs-03.container.cn \
    --net host \
    -v /home/storage/run/docker/glusterfs/data:/bricks:z \
    -v /home/storage/run/docker/glusterfs/conf:/etc/glusterfs:z \
    -v /home/storage/run/docker/glusterfs/meta:/var/lib/glusterd:z \
    -v /home/storage/run/docker/glusterfs/logs:/var/log/glusterfs:z \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v /dev:/dev \
    --cpu-shares 512 --memory 8g --memory-swap 0 \
    -it -d glusterfs:6.4



# 添加节点
podman exec -it glusterfs /usr/sbin/gluster peer probe glusterfs-02.container.cn && \

podman exec -it glusterfs /usr/sbin/gluster peer probe glusterfs-03.container.cn && \

podman exec -it glusterfs /usr/sbin/gluster peer status

podman exec -it glusterfs /usr/sbin/gluster volume create docker replica 3 arbiter 1 transport tcp \
    glusterfs-03.container.cn:/bricks/docker \
    glusterfs-02.container.cn:/bricks/docker \
    glusterfs-01.container.cn:/bricks/docker \
    force

podman exec -it glusterfs /usr/sbin/gluster volume start docker

# 错误处理

### utime
In a case where all servers are upgraded, and we need to still use the old client, please disable the utime feature of the volume.
```sh
podman exec -it glusterfs /usr/sbin/gluster volume set docker ctime off
```

# 客户端挂载
/usr/sbin/glusterfs \
    --direct-io-mode=enable \
    --use-readdirp=no \
    --volfile-server=glusterfs-01.container.cn \
    --volfile-server=glusterfs-02.container.cn \
    --volfile-server=glusterfs-03.container.cn \
    --volfile-server-transport=tcp \
    --volfile-id=docker.tcp \
    /storage/docker

## Systemd

yum install -y glusterfs-client
VOLUME_NAME=docker
cat > /usr/lib/systemd/system/glusterfs-${VOLUME_NAME}.service <<EOF
[Unit]
Description=Gluster File System Mount Volume ${VOLUME_NAME}
After=network.target
After=network-online.target
Wants=network-online.target
Before=kubelet.service

[Service]
Type=forking
ExecStartPre=/bin/bash -c "if [ ! -d "/storage/${VOLUME_NAME}" ]; then mkdir -p /storage/${VOLUME_NAME}; fi"
ExecStart=/usr/sbin/glusterfs \
    --direct-io-mode=enable \
    --use-readdirp=no \
    --volfile-server=glusterfs-01.container.cn \
    --volfile-server=glusterfs-02.container.cn \
    --volfile-server=glusterfs-03.container.cn \
    --volfile-server-transport=tcp \
    --volfile-id=${VOLUME_NAME}.tcp \
    /storage/${VOLUME_NAME}
ExecStop=/bin/kill -HUP \$MAINPID
Restart=on-failure
LimitNOFILE=65536
StartLimitInterval=1
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now glusterfs-${VOLUME_NAME}
