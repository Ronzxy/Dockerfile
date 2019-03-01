#!/bin/bash
# Auto build php in nginx docker container
# 0 0 * * * /path/php-fpm.sh restart > /dev/null 2>&1
# */1 * * * * /path/php-fpm.sh start > /dev/null 2>&1

USER=www
GROUP=www
FPM_CONF=/etc/php/php-fpm.conf
INI_CONF=/etc/php/php.ini
PREFIX=/var
PID_FILE=$PREFIX/run/php-fpm.pid
BIN_NAME=php-fpm

# init env
PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

init_php_env() {
    if [ -d /php/bin ]; then
        mv /php/bin/* /usr/bin && rm -rf /php/bin
        sed -i "s|\#\!.*php|\#\!/usr/bin/php|g" /usr/bin/phar
    fi

    if [ -d /php/sbin ]; then
        mv /php/sbin/* /usr/sbin && rm -rf /php/sbin
    fi

    if [ -d /php/include/php ]; then
        mv /php/include/php /usr/include && rm -rf /php/include
    fi

    if [ -d /php/lib/modules ]; then
        if [ ! -d /usr/lib/php ]; then
            mkdir -p /usr/lib/php
        fi
        
        mv /php/lib/modules /usr/lib/php && rm -rf /php/lib
    fi

    if [ -d /php/share ]; then
        cp -r /php/share/* /usr/share && rm -rf /php/share
    fi

    if [ -f /default.conf ]; then
        mv /default.conf /etc/nginx/conf.d/http
    fi

    if [ "`ls -A ${PHP_CONFIG_PATH}`" = "" ]; then
        cp -r /php/conf/* ${PHP_CONFIG_PATH}
    fi
}

get_php_fpm_pids()  {
    # MacOS Linux
    pids=$(ps aux | grep -e "^.*$BIN_NAME:\s.*$" | awk -F ' ' '{print $2}')

    echo $pids
}

start() {
    init_php_env

    pids=$(get_php_fpm_pids)
    if [ "$pids" == "" ];then
        $BIN_NAME -c $INI_CONF -y $FPM_CONF -p $PREFIX -g $PID_FILE
    else
        echo "$BIN_NAME has already running."
    fi
}

stop() {
    pids=$(get_php_fpm_pids)
    if [ "$pids" == "" ]; then
        echo "$BIN_NAME has stopped."
    else
        kill $pids
    fi
}

status() {
    pids=$(get_php_fpm_pids)
    if [ "$pids" == "" ]; then
        echo "$BIN_NAME is stopped."
    else
        echo "$BIN_NAME (pid  $pids) is running..."
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status $exec
        ;;
    restart)
        stop
        sleep 5
        start
        ;;
    *)
        echo $"Usage: {start | stop | status | restart}"
        exit 1
esac
