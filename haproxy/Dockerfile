FROM debian:jessie

MAINTAINER HAPROXY Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list
#RUN echo "deb-src http://mirrors.163.com/debian/ jessie main" >> /etc/apt/sources.list

# 安装依赖包
RUN apt-get update && \
    apt-get install -y libpcre3 zlib1g libssl1.0.0/stable &&\
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# 复制数据
COPY haproxy /haproxy

WORKDIR /haproxy

RUN chmod 755 startup.sh

EXPOSE 80 443 8443 13501-13510

CMD ["./startup.sh"]
