FROM nginx:1.15.9

# 安装依赖包
RUN apt update && \
    apt install -y libpcre3 zlib1g openssl locales procps \
        libx11-6 libxpm4 libsnmp30 libfreetype6 libcurl3-gnutls libxml2 libc-client2007e \
        libtidy5 libmcrypt4 libkrb5-3 libxslt1.1 libjpeg62-turbo icu-devtools unixodbc \
        libpq5 libsqlite3-0 mysql-common default-libmysqlclient-dev libzip4 libreadline7 && \
    apt upgrade -y && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 配置系统环境
RUN printf "zh_CN.UTF-8 UTF-8\\n" >> /etc/locale.gen && locale-gen && \
    echo "Asia/Shanghai" > /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# RUN mkdir /php

WORKDIR /

ENV PHP_CONFIG_PATH=/etc/php

# 复制数据
COPY dist/php /php
COPY php-fpm.sh /
COPY nginx/default.conf /

RUN chmod 755 /php-fpm.sh && \
    sed -i "s|/usr/sbin/nginx -g \"daemon off;\"|/php-fpm.sh start\n\n&|g" /startup.sh

EXPOSE 80 443

CMD ["./startup.sh"]
