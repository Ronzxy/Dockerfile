#!/bin/bash

FROM nginx:latest

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list
#RUN echo "deb-src http://mirrors.163.com/debian/ jessie main" >> /etc/apt/sources.list

# 安装依赖包
RUN apt-get update && \
    apt-get install -y gcc g++ make autoconf pkg-config \
libjpeg-dev libpng12-dev zlib1g-dev libxml2-dev libssl-dev libbison-dev libpcre3-dev libbz2-dev \
libcurl4-gnutls-dev libxpm-dev libfreetype6-dev libgmp3-dev libc-client-dev libkrb5-dev \
libicu-dev libldap2-dev libsasl2-dev libmcrypt-dev unixodbc-dev libsnmp-dev libtidy-dev libxslt-dev \
libpq-dev libmysqlclient-dev libsqlite3-dev

RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h && \
    ln -s /usr/lib/x86_64-linux-gnu/libldap_r.so /usr/lib/libldap.so

COPY docker-build-sources /docker-build-sources

WORKDIR /docker-build-sources

RUN ./configure \
--prefix=/usr \
--exec-prefix=/usr \
--sysconfdir=/etc/php \
--datadir=/usr/share \
--includedir=/usr/include \
--libdir=/usr/lib64 \
--libexecdir=/usr/libexec \
--localstatedir=/var \
--sharedstatedir=/var/lib \
--mandir=/usr/share/man \
--infodir=/usr/share/info \
--cache-file=../config.cache \
--with-config-file-path=/etc/php \
--with-config-file-scan-dir=/etc/php.d \
--disable-debug \
\
--with-libxml-dir=/usr \
--with-jpeg-dir=/usr \
--with-freetype-dir=/usr \
--with-png-dir=/usr \
--with-xpm-dir=/usr \
--with-icu-dir=/usr \
--with-pcre-regex \
\
--without-readline \
--without-gdbm \
--without-pear \
--disable-rpath \
--with-layout=GNU \
\
--with-iconv=shared \
--with-pic=shared \
--with-imap=shared \
--with-imap-ssl=shared \
--with-kerberos \
--with-bz2=shared \
--enable-gd-native-ttf=shared \
--with-gettext=shared \
--with-gmp=shared \
--with-openssl=shared \
--with-mhash=shared \
--with-mcrypt=shared \
--with-zlib=shared \
--enable-exif=shared \
--enable-ftp=shared \
--enable-sockets=shared \
--enable-sysvsem=shared \
--enable-sysvshm=shared \
--enable-sysvmsg=shared \
--enable-shmop=shared \
--enable-calendar=shared \
--enable-xml=shared \
--enable-pcntl=shared \
--enable-mbstring=shared \
--enable-mbregex=shared \
--with-gd=shared \
--enable-bcmath=shared \
--with-xmlrpc=shared \
--with-ldap=shared \
--with-ldap-sasl \
--enable-dom=shared \
--enable-wddx=shared \
--with-snmp=shared,/usr \
--enable-soap=shared \
--with-xsl=shared,/usr \
--enable-xmlreader=shared \
--enable-xmlwriter=shared \
--with-curl=shared,/usr \
--enable-json=shared \
--enable-zip=shared \
--enable-phar=shared \
--with-tidy=shared,/usr \
--enable-sysvmsg=shared \
--enable-sysvshm=shared \
--enable-sysvsem=shared \
--enable-posix=shared \
--with-unixODBC=shared,/usr \
--enable-fileinfo=shared \
--enable-intl=shared \
\
--enable-pdo=shared \
--with-pdo-odbc=shared,unixODBC,/usr \
\
--with-sqlite3=shared \
--with-pdo-sqlite=shared,/usr \
\
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
--with-mysqli=shared,/usr/bin/mysql_config \
--with-pdo-mysql=shared,/usr/bin/mysql_config \
--with-pgsql=shared,/usr \
--with-pdo-pgsql=shared,/usr

# make ZEND_EXTRA_LIBS='-liconv'
RUN make && make install

RUN cp php.ini-development php.ini-production /etc/php && \
    cp /etc/php/php.ini-production /etc/php/php.ini && \
    cp /etc/php/php-fpm.conf.default /etc/php/php-fpm.conf && \
    cp /etc/php/php-fpm.d/www.conf.default /etc/php/php-fpm.d/www.conf

RUN rm -rf /docker-build-sources

RUN mkdir -p /etc/php.d

RUN apt-get install -y libx11-6 libxpm4 libsnmp30 libfreetype6 libcurl3-gnutls libxml2 libc-client2007e \
libtidy-0.99-0 libmcrypt4 libkrb5-3 libxslt1.1 libjpeg62-turbo icu-devtools unixodbc \
libpq5 libsqlite3-0 mysql-common libmysqlclient18

RUN apt-get purge -y gcc g++ make autoconf pkg-config \
libjpeg-dev libpng12-dev zlib1g-dev libxml2-dev libssl-dev libbison-dev libpcre3-dev libbz2-dev \
libcurl4-gnutls-dev libxpm-dev libfreetype6-dev libgmp3-dev libc-client-dev libkrb5-dev \
libicu-dev libldap2-dev libsasl2-dev libmcrypt-dev unixodbc-dev libsnmp-dev libtidy-dev libxslt-dev \
libpq-dev libmysqlclient-dev libsqlite3-dev

RUN apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

# 复制数据
COPY startup.sh /
COPY php-fpm.sh /
RUN chmod 755 /startup.sh /php-fpm.sh

EXPOSE 80 443

CMD ["./startup.sh"]
