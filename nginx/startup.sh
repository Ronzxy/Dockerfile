#!/bin/bash

# 创建目录及修改权限
mkdir -p /var/cache/nginx /var/log/nginx
chown -R www:www /var/cache/nginx /var/log/nginx

/usr/sbin/nginx -g "daemon off;"
