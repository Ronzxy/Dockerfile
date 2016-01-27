FROM debian:jessie

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y libaio1 net-tools bc original-awk && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*
    
# # 建立一个2G的swap文件
# dd if=/dev/zero of=/swapfile bs=1024 count=2048000
# # 转换激活swap
# mkswap /swapfile
# swapon /swapfile
# # 写入/etc/fstab文件，开机装载2G
# echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

WORKDIR /

ADD init.ora /
ADD initXETemp.ora /
ADD chkconfig /sbin/chkconfig
ADD startup.sh /
ADD oracle-xe_11.2.0-2_amd64.deb /tmp

RUN chmod 755 /sbin/chkconfig /startup.sh
RUN ln -s /usr/bin/awk /bin/awk && \
    ln -sf /proc/mounts /etc/mtab
    
    
RUN dpkg --install /tmp/oracle-xe_11.2.0-2_amd64.deb && \
    rm /tmp/oracle-xe_11.2.0-2_amd64.deb
    

RUN sed -i 's;/var/lock/subsys/listener;/var/lock/listener;' /etc/init.d/oracle-xe
RUN sed -i 's;/var/lock/subsys/oracle-xe;/var/lock/oracle-xe;' /etc/init.d/oracle-xe

RUN mv /init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
RUN mv /initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts

# 这里修改 ORACLE XE 的 configure 参数
RUN printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure

RUN echo 'export ORACLE_BASE=/u01/app/oracle' >> /etc/bash.bashrc
RUN echo 'export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/xe' >> /etc/bash.bashrc
RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
RUN echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc

#VOLUME /usr/lib/oracle/xe/oradata/XE
VOLUME /oradata

EXPOSE 1521
EXPOSE 8080

CMD ["./startup.sh"]
