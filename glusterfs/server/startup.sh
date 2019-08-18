#!/bin/sh

GLUSTERFS_CONF_DIR="/etc/glusterfs"
GLUSTERFS_META_DIR="/var/lib/glusterd"

for DIR in $GLUSTERFS_CONF_DIR $GLUSTERFS_META_DIR; do
	if ! test "$(ls ${DIR})"; then
		cp -af /backup/${DIR}/* ${DIR}
		if [ $? -eq 1 ]; then
			echo "Failed to copy ${DIR}"
			exit 1
		fi
	fi
done

/usr/sbin/glusterd -N -p /var/run/glusterd.pid --log-level INFO
