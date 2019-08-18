FROM debian:buster

RUN echo "deb http://mirrors.aliyun.com/debian/ buster main" > /etc/apt/sources.list

# 安装依赖包
RUN apt update && \
    apt install -y wget gnupg apt-transport-https locales && \
    apt upgrade -y && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 配置系统环境
# RUN grep "^zh_CN.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen && \
#     grep "^en_US.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen && \
#     locale-gen
RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV GLUSTER_VERSION=5.5
ENV REDIS_DATA_PATH=/var/lib/redis
ENV VOLFILE_CHECK=YES
ENV DIRECT_IO_MODE=auto

WORKDIR /

RUN DEB_VERSION=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"') && \
    DEB_RELEASE=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+') && \
    DEB_ARCH=$(dpkg --print-architecture) && \
    wget -nv -O - https://download.gluster.org/pub/gluster/glusterfs/6/rsa.pub | apt-key add - && \
    echo deb [arch=${DEB_ARCH}] https://download.gluster.org/pub/gluster/glusterfs/6/LATEST/Debian/${DEB_RELEASE}/${DEB_ARCH}/apt ${DEB_RELEASE} main > /etc/apt/sources.list.d/glusterfs.list && \
    apt update && \
    apt install -y glusterfs-server && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 复制数据
COPY startup.sh /

RUN chmod 755 /startup.sh && \
    mkdir -p /backup/etc/glusterfs /backup/var/lib/glusterd && \
    cp -af /etc/glusterfs/* /backup/etc/glusterfs/ && \
    cp -af /var/lib/glusterd/* /backup/var/lib/glusterd/

EXPOSE 2222 111 245 443 24007 2049 8080 6010 6011 6012 38465 38466 38468 38469 49152 49153 49154 49156 49157 49158 49159 49160 49161 49162

CMD ["./startup.sh"]
