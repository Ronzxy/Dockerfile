#!/bin/sh
# docker entry point for mongodb
# Powered by cr: zhangchaoren@openeasy.net


bindIp=$(/sbin/ifconfig|grep -v 127.0.0.1|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p' | tr '\n' ',')
sed -i "s/bindIp: .*/bindIp: ${bindIp}127.0.0.1/g" /etc/mongod.conf

if [ "$AUTH" = "YES" ]; then
	EXT_CMD=--auth
fi

/usr/bin/mongod $EXT_CMD --config /etc/mongod.conf
