FROM debian:jessie

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y vsftpd db-util &&\
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# 添加用户
RUN groupadd -r vsftpd && \
    useradd -m -r -g vsftpd vsftpd -d /var/ftp -s /sbin/nologin

WORKDIR /

# 创建目录与初始化文件
RUN mkdir -p /etc/vsftpd/user_conf.d && \
    mkdir -p /var/run/vsftpd/empty && \
    touch /etc/vsftpd/chroot_list && \
    echo "auth required /lib/x86_64-linux-gnu/security/pam_userdb.so db=/etc/vsftpd/user" > /etc/pam.d/vsftpd && \
    echo "account required /lib/x86_64-linux-gnu/security/pam_userdb.so db=/etc/vsftpd/user" >> /etc/pam.d/vsftpd

# 复制数据
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 21

CMD ["./startup.sh"]
