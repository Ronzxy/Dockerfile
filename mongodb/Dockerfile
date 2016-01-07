FROM debian:wheezy

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ wheezy main" > /etc/apt/sources.list && \
    echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv EA312927 && \
    apt-get update && \
    apt-get install -y net-tools mongodb-org=3.2.0 && \
    echo "mongodb-org hold" | dpkg --set-selections && \
    echo "mongodb-org-server hold" | dpkg --set-selections && \
    echo "mongodb-org-shell hold" | dpkg --set-selections && \
    echo "mongodb-org-mongos hold" | dpkg --set-selections && \
    echo "mongodb-org-tools hold" | dpkg --set-selections && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /
ENV AUTH yes

# 复制数据
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 27017

CMD ["./startup.sh"]
