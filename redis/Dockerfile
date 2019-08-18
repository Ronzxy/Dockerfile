FROM debian:stretch

RUN echo "deb http://mirrors.163.com/debian/ stretch main" > /etc/apt/sources.list

# 安装依赖包
RUN apt update && \
    apt install -y locales && \
    apt upgrade -y && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 配置系统环境
# RUN grep "^zh_CN.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen && \
#     grep "^en_US.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen && \
#     locale-gen
RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV REDIS_PORT=6379
ENV REDIS_DATA_PATH=/var/lib/redis
ENV APPEND_ONLY=yes
ENV CLUSTER_ENABLE=no

WORKDIR /

# 复制数据
COPY dist/redis-5.0.5 /redis
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 6379 16379

CMD ["./startup.sh"]
