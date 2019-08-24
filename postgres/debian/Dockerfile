FROM debian:buster

RUN echo "deb http://mirrors.163.com/debian/ buster main" > /etc/apt/sources.list

RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 升级并清理系统
RUN apt update && \
    apt upgrade -y && \
    apt install -y locales && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 配置系统语言环境
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

# 添加用户
RUN groupadd -r -g 999 postgres && \
    useradd -r -u 999 -g postgres postgres -m -d /home/postgres -s /bin/bash

# 安装依赖包
RUN set -ex && \
    apt install -y libpcre3 zlib1g libreadline-dev libkrb5-dev libldap2-dev \
        libcurl4 libossp-uuid-dev libpython3.5 python3 gettext flex bison libgeos-dev libproj-dev libgdal-dev && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

ENV PGDATA="/var/lib/postgres"
ENV POSTGRES_PASSWORD=""
ENV NETWORK="127.0.0.1/32"
ENV ENABLE_CITUS="YES"
# MASTER/BACKUP
ENV PGTYPE="MASTER"
ENV PGMASTER_HOST=""
ENV PGMASTER_PORT=5432
# SYNC
ENV SYNC_MODE=NONE
ENV SYNC_NAME=""



WORKDIR /

# 复制数据
COPY dist/postgresql-11.5 /usr/postgres
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 5432

ENTRYPOINT ["./startup.sh", "start"]
