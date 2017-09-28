FROM debian:jessie

MAINTAINER Postgres-XL Docker Maintainers "zhangchaoren.cn@gmail.com"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list

# 安装依赖包
RUN apt update && \
    apt install -y locales libreadline-dev libpam-dev libxml2 libxslt-dev \
        libperl-dev libpython-dev zlib1g-dev libssl-dev gettext bison flex && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN export LC_ALL=zh_CN.UTF-8
RUN printf "zh_CN.UTF-8 UTF-8\\nen_US.UTF-8 UTF-8\\n" >> /etc/locale.gen && locale-gen
RUN echo "export LANG=zh_CN.UTF-8" >> /etc/profile
RUN echo "export PATH=$PGHOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin" >> /etc/profile
RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN mkdir /app

# 添加用户
RUN useradd postgres -m -d /app/postgres -s /bin/bash

# 复制程序
COPY dist/postgres /app/postgres
# 复制脚本
COPY startup.sh /

RUN chmod 755 /startup.sh

ENV PGHOME /app/postgres
ENV PGDATA /var/lib/postgres
# Node type: gtm/gtm_proxy/coordinator/datanode
ENV PGNODE "datanode"
# Node name like pgdata01
ENV PGNAME "pgxl"
# Gtm host
ENV PGHOST "localhost"
# Gtm port
ENV PGPORT 6666

EXPOSE 5432 6666-6668 15432-15532

CMD ["./startup.sh"]
