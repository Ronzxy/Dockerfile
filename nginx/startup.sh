#!/bin/bash

if [ -f "/etc/bash.bashrc" ]; then
    grep "LANG=zh_CN.UTF-8" /etc/bash.bashrc > /dev/null 2>&1 || \
        echo "export LANG=zh_CN.UTF-8" >> /etc/bash.bashrc

    grep "PATH=" /etc/bash.bashrc > /dev/null 2>&1 || \
        echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin" >> /etc/bash.bashrc
    source /etc/bash.bashrc
else
    grep "LANG=zh_CN.UTF-8" /etc/profile > /dev/null 2>&1 || \
        echo "export LANG=zh_CN.UTF-8" >> /etc/profile

    grep "PATH=" /etc/profile > /dev/null 2>&1 || \
        echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin" >> /etc/profile
    source /etc/profile
fi

if [ ! -f "/usr/sbin/nginx" ]; then
    cp /nginx/sbin/nginx /usr/sbin
fi

if [ ! -f "/etc/nginx/nginx.conf" ]; then
    if [ ! -d "/etc/nginx" ]; then
        mkdir -p /etc/nginx
    else
        rm -rf /etc/nginx/*
    fi

    cp -r /nginx/conf/* /etc/nginx
fi

if [ ! -d "/home/www/html" ]; then
    cp -r /nginx/html /home/www/html
fi

# 创建目录及修改权限
mkdir -p /var/cache/nginx /var/log/nginx
chown -R www:www /var/cache/nginx /var/log/nginx

/usr/sbin/nginx -g "daemon off;"
