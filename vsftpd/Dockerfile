FROM debian:jessie

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y vsftpd db-util nano-tiny &&\
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
    touch /etc/vsftpd/user.list && \
    echo "auth required /lib/x86_64-linux-gnu/security/pam_userdb.so db=/etc/vsftpd/user" > /etc/pam.d/vsftpd && \
    echo "account required /lib/x86_64-linux-gnu/security/pam_userdb.so db=/etc/vsftpd/user" >> /etc/pam.d/vsftpd

# 复制数据
COPY startup.sh vsftpd.conf user_conf.d chown.sh / 

# 被动模式参数配置
ENV PASV_ADDRESS ""
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110
ENV VSFTPD_DATA "/var/ftp"

RUN chmod 755 /startup.sh

RUN printf "* * * * * db_load -T -t hash -f /etc/vsftpd/user.list /etc/vsftpd/user.db\\n*/15 * * * * sh /etc/vsftpd/chown.sh\\n" | crontab

# 修改时区
RUN printf "\\nTZ='Asia/Shanghai'\\nexport TZ\\n" >> /etc/bash.bashrc

EXPOSE 21

CMD ["./startup.sh"]
