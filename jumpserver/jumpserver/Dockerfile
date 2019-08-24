FROM alpine:3.9

# echo http://dl-2.alpinelinux.org/alpine/edge/main/ >> /etc/apk/repositories && \
# echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
RUN set -ex && \
    apk --no-cache add ca-certificates wget shadow && \
    rm -rf /var/cache/apk/*

# 配置系统语言环境
RUN set -ex && \
    GLIBC_VERSION=2.30-r0 && \
    wget -nv -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -nv https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget -nv https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget -nv https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk add glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk glibc-${GLIBC_VERSION}.apk && \
    rm -rf glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk glibc-${GLIBC_VERSION}.apk

RUN printf "zh_CN\nzh_HK" | xargs -i /usr/glibc-compat/bin/localedef -c -f UTF-8 -i {} {}.UTF-8
ENV LC_ALL=zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN cat /etc/group | grep :999: | awk -F ':' '{print "groupmod -g 1999 "$1}' | sh && \
    groupadd -r -g 999 jumpserver && \
    useradd -r -u 999 -g jumpserver jumpserver -m -d /home/jumpserver -s /bin/bash

ENV JUMPSERVER_VERSION=1.5.2
ENV JUMPSERVER_HOME=/jumpserver

ADD src/jumpserver-${JUMPSERVER_VERSION}.tar.gz /

# 安装依赖包
RUN set -ex && \
    mv /jumpserver-${JUMPSERVER_VERSION} ${JUMPSERVER_HOME} && \
    sed -i "s/mysqlclient.*/postgres==2.2.2\\n&/g" ${JUMPSERVER_HOME}/requirements/requirements.txt && \
    apk --no-cache add bash && \
    apk --no-cache add $(cat ${JUMPSERVER_HOME}/requirements/alpine_requirements.txt) && \
    rm -rf /var/cache/apk/* && \
    pip3 install --upgrade pip setuptools -i https://mirrors.aliyun.com/pypi/simple/ && \
    pip3 install -r  ${JUMPSERVER_HOME}/requirements/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ && \
    rm -rf /root/.cache

# postgresql/mysql
ENV DB_ENGINE=postgresql
ENV DB_HOST=172.17.0.1
ENV DB_PORT=5432
ENV DB_NAME=jumpserver
ENV DB_USER=jumpserver
ENV DB_PASSWORD=Abc123

ENV REDIS_HOST=172.17.0.1
ENV REDIS_PORT=6379
ENV REDIS_PASSWORD=

ENV SECRET_KEY=ww2ZkPHHXbe5ydtpdkG0FoYrSjAnxRfx6RJAqlE959ThckZhHF
ENV BOOTSTRAP_TOKEN=DdC9ASWbpzq6WACk

ENV DEBUG=false
# DEBUG/ERROR
ENV LOG_LEVEL=ERROR

WORKDIR ${JUMPSERVER_HOME}

ADD src/luna-${JUMPSERVER_VERSION}.tar.gz .
ADD startup.sh .
RUN chmod 755 startup.sh

EXPOSE 8080

ENTRYPOINT ["./startup.sh"]
