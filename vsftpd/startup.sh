#!/bin/sh
# docker entry point for vsftpd
# Powered by cr: zhangchaoren@openeasy.net

export LANG=zh_CN.UTF-8

mkdir -p /var/log/vsftpd/

if [ ! -f "/etc/vsftpd/vsftpd.conf" ]; then
    cp /vsftpd.conf /etc/vsftpd/vsftpd.conf
fi

if [ ! -f "/etc/vsftpd/chroot_list" ]; then
    touch /etc/vsftpd/chroot_list
fi

if [ ! -f "/etc/vsftpd/user.list" ]; then
    touch /etc/vsftpd/user.list
fi

if [ ! -f "/etc/vsftpd/chown.sh" ]; then
    cp /chown.sh /etc/vsftpd/chown.sh
fi

if [ ! -f "/etc/vsftpd/.PASV_ADDRESS" ]; then
    touch /etc/vsftpd/.PASV_ADDRESS
    echo $PASV_ADDRESS > /etc/vsftpd/.PASV_ADDRESS
fi

if [ ! -f "/etc/vsftpd/.VSFTPD_DATA" ]; then
    touch /etc/vsftpd/.VSFTPD_DATA
    if [ "$VSFTPD_DATA" = "" ];then
        VSFTPD_DATA=/var/ftp
    else
        echo $VSFTPD_DATA > /etc/vsftpd/.VSFTPD_DATA
    fi
fi

if [ ! -d "/etc/vsftpd/user_conf.d" ]; then
    mkdir -p /etc/vsftpd/user_conf.d
    cp user_conf.d /etc/vsftpd/user_conf.d/example
fi

PASV_ADDRESS=$(cat /etc/vsftpd/.PASV_ADDRESS)
VSFTPD_DATA=$(cat /etc/vsftpd/.VSFTPD_DATA)

if [ "$PASV_ADDRESS" = "" ];then
    PASV_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
fi

if [ "$PASV_MIN_PORT" = "" ];then
    PASV_MIN_PORT=21100
fi

if [ "$PASV_MAX_PORT" = "" ];then
    PASV_MAX_PORT=21110
fi

if [ "$VSFTPD_DATA" = "" ];then
    VSFTPD_DATA=/var/ftp
fi

sed -i "s/pasv_address=.*/pasv_address=${PASV_ADDRESS}/g" /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_min_port=.*/pasv_min_port=${PASV_MIN_PORT}/g" /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_max_port=.*/pasv_max_port=${PASV_MAX_PORT}/g" /etc/vsftpd/vsftpd.conf

chown -R ftp:ftp $VSFTPD_DATA

# 重启 cron 服务
/etc/init.d/cron restart

# 启动 vsftp 服务
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
