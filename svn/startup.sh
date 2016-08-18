#!/bin/bash

export LANG="zh_CN.UTF-8"

# 复制管理命令
cp svnadmin.sh $SVN_BASE/
cp pre-commit $SVN_BASE/

echo "#!/bin/bash

export SVN_BASE=$SVN_BASE
" > $SVN_BASE/VARS

if [[ ! -d "$SVN_BASE/repo" ]]; then
    mkdir -p $SVN_BASE/repo
fi

if [[ ! -d "$SVN_LOGS" ]]; then
    mkdir -p $SVN_LOGS
fi

svnserve --daemon --foreground --root $SVN_BASE/repo --log-file $SVN_LOGS/svn.log
