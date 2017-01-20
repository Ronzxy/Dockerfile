#!/bin/bash

# 启动SSH服务
/etc/init.d/ssh start

tail -f /var/run/sshd.pid
