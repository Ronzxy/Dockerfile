#!/bin/bash

WORK_DIR=$(pwd)
CONF_FILE=$WORK_DIR/conf/haproxy.cfg
PID_FILE=$WORK_DIR/haproxy.pid
BIN_FILE=$WORK_DIR/sbin/haproxy

ulimit -u 204800 -HSn 204800

chmod 755 $BIN_FILE
sleep 3
$BIN_FILE -f $CONF_FILE -p $PID_FILE
