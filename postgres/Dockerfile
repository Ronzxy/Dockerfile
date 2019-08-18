FROM debian:stretch

RUN echo "deb http://mirrors.aliyun.com/debian/ stretch main" > /etc/apt/sources.list

# 安装依赖包
RUN apt update && \
    apt install -y libpcre3 zlib1g libreadline-dev libkrb5-dev libldap2-dev \
        libcurl3 libossp-uuid-dev libpython3.5 python3 gettext flex bison locales && \
    apt upgrade -y && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 配置系统环境
# RUN grep "^zh_CN.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen && \
#     locale-gen
RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV PGDATA="/var/lib/postgres"
ENV POSTGRES_PASSWORD=""
ENV NETWORK="127.0.0.1/32"
ENV ENABLE_CITUS="YES"
# MASTER/BACKUP
ENV PGTYPE="MASTER"
ENV PGMASTER_HOST=""
ENV PGMASTER_PORT=5432
ENV SYNC_MODE=SYNC
ENV SYNC_NAME=""

# 添加用户
RUN groupadd -r -g 999 postgres && \
    useradd -r -u 999 -g postgres postgres -m -d /home/postgres -s /bin/bash

WORKDIR /

# 复制数据
COPY dist/postgresql-11.5 /usr/postgres
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 5432

CMD ["./startup.sh", "start"]
