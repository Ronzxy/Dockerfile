FROM alpine:3.10

RUN set -ex && \
    echo http://dl-2.alpinelinux.org/alpine/edge/main/ >> /etc/apk/repositories && \
    echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    echo http://dl-2.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories && \
    apk add shadow tzdata && \
    rm -rf /var/cache/apk/*

# 配置系统语言环境
RUN set -ex && \
    GLIBC_VERSION=2.30-r0 && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk add glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk glibc-${GLIBC_VERSION}.apk && \
    rm -rf glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk glibc-${GLIBC_VERSION}.apk && \
    rm -rf /var/cache/apk/*

RUN printf "zh_CN\nzh_HK" | xargs -i /usr/glibc-compat/bin/localedef -c -f UTF-8 -i {} {}.UTF-8
ENV LC_ALL=zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 添加用户
RUN cat /etc/group | grep :999: | awk -F ':' '{print "groupmod -g 1999 "$1}' | sh && \
    cat /etc/group | grep postgres: | awk -F ':' '{print "groupmod -g 999 "$1}' | sh && \
    cat /etc/group | grep postgres: | awk -F ':' '{print "usermod -u 999 "$1}' | sh

# 安装依赖包
RUN set -ex && \
    apk upgrade && \
    apk add zlib libssl1.1 libxml2 readline libxslt libcurl ossp-uuid libselinux icu-libs flex bison geos proj gdal && \
    rm -rf /var/cache/apk/*

    # # --enable-tap-tests \
    # apk add perl-ipc-run

    # # --enable-nls="zh_CN" 在 alpine 会产生编译错误
    # apk add gettext

    # # 这些功能会造成容器尺寸非常巨大
    # # --with-gssapi \
    # # --with-ldap \
    # # --with-tcl \
    # # --with-perl \
    # # --with-python \
    # # --with-pam \
    # apk add krb5-libs libldap linux-pam python3 tcl perl

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

# 复制数据
COPY dist/postgresql-11.5 /usr/postgres
COPY startup.sh /usr/postgres

WORKDIR /usr/postgres

RUN chmod 755 startup.sh

EXPOSE 5432

CMD ["./startup.sh", "start"]
