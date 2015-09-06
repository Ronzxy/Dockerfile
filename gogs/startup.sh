#!/bin/bash

if ! test -d $GOGS_CUSTOM/gogs
then
	mkdir -p /var/run/sshd
	mkdir -p $GOGS_CUSTOM/gogs/data $GOGS_CUSTOM/gogs/conf $GOGS_CUSTOM/gogs/log $GOGS_CUSTOM/git
fi

if ! test -d $GOGS_CUSTOM/ssh
then
	mkdir $GOGS_CUSTOM/ssh
	ssh-keygen -q -f $GOGS_CUSTOM/ssh/ssh_host_key -N '' -t rsa1
	ssh-keygen -q -f $GOGS_CUSTOM/ssh/ssh_host_rsa_key -N '' -t rsa
	ssh-keygen -q -f $GOGS_CUSTOM/ssh/ssh_host_dsa_key -N '' -t dsa
	ssh-keygen -q -f $GOGS_CUSTOM/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
	ssh-keygen -q -f $GOGS_CUSTOM/ssh/ssh_host_ed25519_key -N '' -t ed25519
	chown -R root:root $GOGS_CUSTOM/ssh/*
	chmod 600 $GOGS_CUSTOM/ssh/*
fi

/etc/init.d/ssh start

ln -sf $GOGS_CUSTOM/gogs/log ./log
ln -sf $GOGS_CUSTOM/gogs/data ./data
ln -sf $GOGS_CUSTOM/git /home/git

test -d $GOGS_CUSTOM/gogs/templates || cp -ar ./templates $GOGS_CUSTOM/gogs/
rsync -rtv $GOGS_CUSTOM/gogs/templates/ ./templates/

if ! test -d /home/git/.ssh
then
    mkdir -p /home/git/.ssh
    chmod 700 /home/git/.ssh
	chown -R git:git /home/git/.ssh
fi

export GIT_SSL_NO_VERIFY=1
exec su git -c "./gogs web"
