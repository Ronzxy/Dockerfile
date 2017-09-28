#!/bin/bash


PATH=$PGHOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

USER=postgres
GROUP=postgres

init_gtm() {
    su - postgres -c "$PGHOME/bin/initgtm -Z gtm -D $PGDATA"
    cp $PGDATA/gtm.conf $PGDATA/gtm.conf.sample

    sed -i -E "s/nodename = 'one'/nodename = '$PGNAME'/g" $PGDATA/gtm.conf
    sed -i -E "s/#listen_addresses = '\*'/listen_addresses = '*'/g" $PGDATA/gtm.conf

    if [ $PGHOST = "localhost" ];then
        sed -i -E "s/#startup = ACT/startup = ACT /g" $PGDATA/gtm.conf
    else
        sed -i -E "s/#startup = ACT/startup = STANDBY/g" $PGDATA/gtm.conf
        sed -i -E "s/#active_host = ''/active_host = '$PGHOST'/g" $PGDATA/gtm.conf
        sed -i -E "s/#active_port =/active_port = $PGPORT/g" $PGDATA/gtm.conf
    fi
}

init_gtm_proxy() {
    su - postgres -c "$PGHOME/bin/initgtm -Z gtm_proxy -D $PGDATA"
    cp $PGDATA/gtm_proxy.conf $PGDATA/gtm_proxy.conf.sample

    sed -i -E "s/nodename = 'one'/nodename = '$PGNAME'/g" $PGDATA/gtm_proxy.conf
    sed -i -E "s/#listen_addresses = '\*'/listen_addresses = '*'/g" $PGDATA/gtm_proxy.conf
    # GTM settings
    sed -i -E "s/gtm_host = 'localhost'/gtm_host = '$PGHOST'/g" $PGDATA/gtm_proxy.conf
    sed -i -E "s/gtm_port = 6668/gtm_port = $PGPORT/g" $PGDATA/gtm_proxy.conf
}

init_db() {
    su - postgres -c "$PGHOME/bin/initdb -D $PGDATA -E UTF8 --locale zh_CN.UTF-8 --nodename $PGNAME"
    cp $PGDATA/postgresql.conf $PGDATA/postgresql.conf.sample

    sed -i -E "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" $PGDATA/postgresql.conf
    if [ "$PGNODE" = "coordinator" ];then
        sed -i -E "s/#port = 5432/port = 5432/g" $PGDATA/postgresql.conf
    else
        sed -i -E "s/#port = 5432/port = 15432/g" $PGDATA/postgresql.conf
    fi
    # sed -i -E "s/max_connections = 100/max_connections = 100/g" $PGDATA/postgresql.conf
    # Setting pool
    if [ "$PGNODE" = "coordinator" ];then
        sed -i -E "s/#pooler_port = 6667/pooler_port = 6667/g" $PGDATA/postgresql.conf
    else
        sed -i -E "s/#pooler_port = 6667/pooler_port = 6668/g" $PGDATA/postgresql.conf
    fi
    
    sed -i -E "s/#max_pool_size = 100/max_pool_size = 1024/g" $PGDATA/postgresql.conf
    sed -i -E "s/#pool_conn_keepalive = 600/pool_conn_keepalive = 600/g" $PGDATA/postgresql.conf
    sed -i -E "s/#pool_maintenance_timeout = 30/pool_maintenance_timeout = 30/g" $PGDATA/postgresql.conf
    # GTM settings
    sed -i -E "s/#gtm_host = 'localhost'/gtm_host = '$PGHOST'/g" $PGDATA/postgresql.conf
    sed -i -E "s/#gtm_port = 6666/gtm_port = $PGPORT/g" $PGDATA/postgresql.conf

    # Setting pg_hba
    echo "host    all             all             127.0.0.1               trust" >> $PGDATA/pg_hba.conf
    echo "host    all             all             all                     md5" >> $PGDATA/pg_hba.conf
}

read_pgxl_env() {
    # PGHOME
    PGHOME=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

    if [ -f $PGHOME/PGXL_ENV ]; then
        # Get env in $PGHOME/PGXL_ENV
        PGHOME=$(grep 'PGHOME' $PGHOME/PGXL_ENV | awk -F '=' '{print $2}')
        # PGDATA
        PGDATA=$(grep 'PGDATA' $PGHOME/PGXL_ENV | awk -F '=' '{print $2}')
        # Node type: gtm/gtm_proxy/coordinator/datanode
        PGNODE=$(grep 'PGNODE' $PGHOME/PGXL_ENV | awk -F '=' '{print $2}')
        # Node name like pgdata01
        PGNAME=$(grep 'PGNAME' $PGHOME/PGXL_ENV | awk -F '=' '{print $2}')
        # Gtm host
        PGHOST=$(grep 'PGHOST' $PGHOME/PGXL_ENV | awk -F '=' '{print $2}')
        # Gtm port
        PGPORT=$(grep 'PGPORT' $PGHOME/PGXL_ENV | awk -F '=' '{print $2}')
    else
        echo "Error: Configuration file '$PGHOME/PGXL_ENV' not found."
        exit 1
    fi
}

check_ld_conf() {
    if [ ! -s "/etc/ld.so.conf.d/postgres" ]; then
        echo "$PGHOME/lib" > /etc/ld.so.conf.d/postgres
        ldconfig $PGHOME/lib
    fi
}

init_pgxc() {
    echo "Initial Postgre-XL..."

    read_pgxl_env
    check_ld_conf

    mkdir -p $PGDATA
    chown -R $USER:$GROUP $PGDATA

    # 初始化 pgxc
    if [ "$PGNODE" = "gtm" ];then
        if [ "$PGHOST" = "localhost" ]; then
            echo "Postgre-XL node is GTM."
        else
            echo "Postgre-XL node is GTM-Standby." 
        fi

        init_gtm
    fi

    if [ "$PGNODE" = "gtm_proxy" ];then
        echo "Postgre-XL node is GTM-Proxy."

        init_gtm_proxy
    fi

    if [ "$PGNODE" = "coordinator" -o "$PGNODE" = "datanode" ];then
        echo "Postgre-XL node is $PGNODE."

        init_db
    fi
}
  
# 启动顺序: GTM->GTM-Standby->GTM-Proxy->Coordinators->Datanodes
# 关闭顺序: Coordinators->Datanodes->GTM-Proxy->GTM-Standby->GTM  
start_pgxc() {
    echo "Starting..."
    read_pgxl_env
    check_ld_conf

    ulimit -u 65535 -HSn 65536
    chown -R $USER:$GROUP $PGDATA

    if [ "$PGNODE" = "gtm" ];then
        su - postgres -c "$PGHOME/bin/gtm -D $PGDATA" & > /dev/null 2>&1
    fi

    if [ "$PGNODE" = "gtm_proxy" ];then
        su - postgres -c "$PGHOME/bin/gtm_proxy -D $PGDATA" & > /dev/null 2>&1
    fi

    if [ "$PGNODE" = "coordinator" ];then
        su - postgres -c "$PGHOME/bin/postgres --coordinator -D $PGDATA" & > /dev/null 2>&1
    fi

    if [ "$PGNODE" = "datanode" ];then
        su - postgres -c "$PGHOME/bin/postgres --datanode -D $PGDATA" & > /dev/null 2>&1
    fi

    echo "Started."
}

stop_pgxc() {
    echo "Stopping..."
    read_pgxl_env
    check_ld_conf
    echo "Stopped."
}

# 检查是否为 root 用户
if [ "$(id -u)" != "0" ]; then
    echo "Error: Please use the root user to execute this shell."
    exit 1
fi

case "$1" in
    init)
        init_pgxc
        exit 0
    ;;
    start)
        start_pgxc
        exit 0
    ;;
    stop)
        stop_pgxc
        exit 0
    ;;
    restart)
        stop_pgxc
        sleep 5
        start_pgxc
    ;;
    *)
        echo $"Usage: {start | stop | restart | status}"
        exit 1
    ;;
esac
