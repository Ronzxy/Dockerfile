#!/bin/bash

CREATE_REPO=$1
WORK_DIR=$(pwd)

. VARS

if [[ $1 == "" ]]; then
    echo "Repo name can not be empty."
    exit 1
fi

if [[ -d "$CREATE_REPO" ]]; then
    echo "$CREATE_REPO has alreay exists."
    exit 1
fi

svnadmin create $CREATE_REPO

echo "[general]
anon-access = none
auth-access = write
password-db = $SVN_BASE/repo/conf/passwd
authz-db = $SVN_BASE/repo/conf/authz
" > $CREATE_REPO/conf/svnserve.conf

cp pre-commit $CREATE_REPO/hooks

if [[ ! -d "$WORK_DIR/repo/conf" ]]; then
    mkdir -p $WORK_DIR/repo/conf
    cp $CREATE_REPO/conf/passwd $CREATE_REPO/conf/authz $WORK_DIR/repo/conf
fi

mv $CREATE_REPO $WORK_DIR/repo/
