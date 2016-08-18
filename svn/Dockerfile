FROM debian:jessie

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list
#RUN echo "deb-src http://mirrors.163.com/debian/ jessie main" >> /etc/apt/sources.list

# 安装依赖包
RUN apt-get update && \
    apt-get install -y subversion && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*


ENV SVN_BASE /data
ENV SVN_LOGS /logs

# 添加用户
RUN groupadd -r svn && \
    useradd -r -g svn svn -d /opt/svn -s /sbin/nologin

WORKDIR /

COPY startup.sh /
COPY svnadmin.sh /
COPY pre-commit /

RUN chmod 755 /startup.sh /svnadmin.sh /pre-commit

EXPOSE 3690

CMD ["./startup.sh"]
