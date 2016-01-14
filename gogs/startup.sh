#!/bin/bash

export GIT_SSL_NO_VERIFY=1

if ! test -d $GOGS_DATA/gogs
then
	mkdir -p /var/run/sshd
	mkdir -p $GOGS_DATA/gogs/data $GOGS_DATA/gogs/log
fi

if ! test -d $GOGS_DATA/conf
then
	mkdir -p $GOGS_DATA/conf
fi

if ! test -d $GOGS_DATA/git
then
	mkdir -p $GOGS_DATA/git
fi

if ! test -d $GOGS_DATA/ssh
then
	mkdir $GOGS_DATA/ssh
	ssh-keygen -q -f $GOGS_DATA/ssh/ssh_host_key -N '' -t rsa1
	ssh-keygen -q -f $GOGS_DATA/ssh/ssh_host_rsa_key -N '' -t rsa
	ssh-keygen -q -f $GOGS_DATA/ssh/ssh_host_dsa_key -N '' -t dsa
	ssh-keygen -q -f $GOGS_DATA/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
	ssh-keygen -q -f $GOGS_DATA/ssh/ssh_host_ed25519_key -N '' -t ed25519
	chown -R root:root $GOGS_DATA/ssh/*
	chmod 600 $GOGS_DATA/ssh/*
fi

/etc/init.d/ssh start

rm -rf /gogs/log /gogs/data /home/git
ln -sf $GOGS_DATA/gogs/log /gogs/log
ln -sf $GOGS_DATA/gogs/data /gogs/data
ln -sf $GOGS_DATA/git /home/git

test -d $GOGS_DATA/gogs/templates || cp -ar ./templates $GOGS_DATA/gogs/
rsync -rtv $GOGS_DATA/gogs/templates/ ./templates/

if ! test -d /home/git/.ssh
then
    mkdir -p /home/git/.ssh
    chmod 700 /home/git/.ssh
	chown -R git:git /home/git
fi

chown -R git:git $GOGS_DATA
# 指定GOGS自定义数据目录
export GOGS_CUSTOM=$GOGS_DATA

exec su git -c "export GIT_SSL_NO_VERIFY=1;./gogs web"
