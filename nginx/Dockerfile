FROM debian:jessie

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list
#RUN echo "deb-src http://mirrors.163.com/debian/ jessie main" >> /etc/apt/sources.list

# 安装依赖包
RUN apt-get update && \
    apt-get install -y libpcre3 zlib1g libssl1.0.0/stable google-perftools/stable &&\
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# 添加用户
RUN groupadd -r www && \
    useradd -r -g www www -d /opt/www -s /sbin/nologin

WORKDIR /

# 复制数据
COPY nginx/sbin/nginx /usr/sbin/
COPY nginx/conf /etc/nginx
COPY nginx/html /usr/html
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 80 443

CMD ["./startup.sh"]
