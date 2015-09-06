FROM debian:jessie

MAINTAINER GOGS Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list
#RUN echo "deb-src http://mirrors.163.com/debian/ jessie main" >> /etc/apt/sources.list

# 安装依赖包
RUN apt-get update && \
    apt-get install -y git openssh-server && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# 添加用户
RUN useradd --shell /bin/bash --system --comment gogits git

ENV GOGS_CUSTOM /data
WORKDIR /gogs

COPY gogs /gogs
COPY startup.sh /gogs/
RUN chmod 755 /gogs/startup.sh
# 创建目录及修改权限
RUN mkdir -p /data && \
    chown -R git:git /gogs /data

EXPOSE 22 3000

CMD ["./startup.sh"]
