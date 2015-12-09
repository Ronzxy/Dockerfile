#!/bin/bash
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

getPids()  {
    # MacOS Linux
    pids=$(ps aux | grep -e "^.*$BIN_NAME:\s.*$" | awk -F ' ' '{print $2}')

    echo $pids
}


start() {
    pids=$(getPids)
    if [ "$pids" == "" ];then
        $BIN_NAME -c $INI_CONF -y $FPM_CONF -p $PREFIX -g $PID_FILE
    else
        echo "$BIN_NAME has already running."
    fi
}

stop() {
    pids=$(getPids)
    if [ "$pids" == "" ]; then
        echo "$BIN_NAME has stopped."
    else
        kill $pids
    fi
}

status() {
    pids=$(getPids)
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
