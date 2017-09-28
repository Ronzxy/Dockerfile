Postgres-XC
===========

# 在所有 Coordinator 节点执行
```sql
CREATE NODE pgxl_coord01 with (type = 'coordinator', host = '10.20.0.23', port = 5432);
CREATE NODE pgxl_datanode01 with (type = 'datanode', host = '10.20.0.23', port = 15432, primary = true);

CREATE NODE pgxl_coord02 with (type = 'coordinator', host = '10.20.0.24', port = 5432);
CREATE NODE pgxl_datanode02 with (type = 'datanode', host = '10.20.0.24', port = 15432, primary = true);

CREATE NODE pgxl_coord03 with (type = 'coordinator', host = '10.20.0.25', port = 5432);
CREATE NODE pgxl_datanode03 with (type = 'datanode', host = '10.20.0.25', port = 15432, primary = true);

SELECT pgxc_pool_reload();
```

PASSWD=$(LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 9)

DROP NODE pgcoor_01;

ALTER NODE pgcoor_01 with(TYPE = 'coordinator', HOST='192.168.1.7', PORT=1922);

SELECT pgxc_pool_reload();
SELECT * FROM pgxc_node;

ALTER USER postgres WITH SUPERUSER PASSWORD 'MqSFo5uYk';

su - postgres -c "pg_ctl stop -D /var/lib/postgres"




# 启动顺序: GTM->GTM-Standby->GTM-Proxy->Coordinators->Datanodes
# 关闭顺序: Coordinators->Datanodes->GTM-Proxy->GTM-Standby->GTM  

# GTM
docker run --name pgxl_gtm_master \
-p 6666:6666 \
-e PGNODE=gtm -e PGNAME=gtm_master \
-e PGHOST=localhost -e PGPORT=6666 \
-v /data/run/docker/pgxl/gtm_master/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# GTM Standby
docker run --name pgxl_gtm_sandby01 \
-p 6666:6666 \
-e PGNODE=gtm -e PGNAME=pgxl_gtm_sandby01 \
-e PGHOST=10.20.0.21 -e PGPORT=6666 \
-v /data/run/docker/pgxl/gtm_sandby01/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# 1
#
# GTM Proxy
docker run --name pgxl_gtm_proxy01 \
-p 6666:6666 \
-e PGNODE=gtm_proxy -e PGNAME=pgxl_gtm_proxy01 \
-e PGHOST=10.20.0.21 -e PGPORT=6666 \
-v /data/run/docker/pgxl/gtm_proxy01/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# Coordinator
docker run --name pgxl_coord01 \
-p 5432:5432 \
-e PGNODE=coordinator -e PGNAME=pgxl_coord01 \
-e PGHOST=10.20.0.23 -e PGPORT=6666 \
-v /data/run/docker/pgxl/coord01/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# DataNode
docker run --name pgxl_datanode01 \
-p 15432:15432 \
-e PGNODE=datanode -e PGNAME=pgxl_datanode01 \
-e PGHOST=10.20.0.23 -e PGPORT=6666 \
-v /data/run/docker/pgxl/datanode01/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# 2
#
# GTM Proxy
docker run --name pgxl_gtm_proxy02 \
-p 6666:6666 \
-e PGNODE=gtm_proxy -e PGNAME=pgxl_gtm_proxy02 \
-e PGHOST=10.20.0.21 -e PGPORT=6666 \
-v /data/run/docker/pgxl/gtm_proxy02/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# Coordinator
docker run --name pgxl_coord02 \
-p 5432:5432 \
-e PGNODE=coordinator -e PGNAME=pgxl_coord02 \
-e PGHOST=10.20.0.24 -e PGPORT=6666 \
-v /data/run/docker/pgxl/coord02/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# DataNode
docker run --name pgxl_datanode02 \
-p 15432:15432 \
-e PGNODE=datanode -e PGNAME=pgxl_datanode02 \
-e PGHOST=10.20.0.25 -e PGPORT=6666 \
-v /data/run/docker/pgxl/datanode02/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6


# 3
#
# GTM Proxy
docker run --name pgxl_gtm_proxy03 \
-p 6666:6666 \
-e PGNODE=gtm_proxy -e PGNAME=pgxl_gtm_proxy03 \
-e PGHOST=10.20.0.21 -e PGPORT=6666 \
-v /data/run/docker/pgxl/gtm_proxy03/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# Coordinator
docker run --name pgxl_coord03 \
-p 5432:5432 \
-e PGNODE=coordinator -e PGNAME=pgxl_coord03 \
-e PGHOST=10.20.0.25 -e PGPORT=6666 \
-v /data/run/docker/pgxl/coord03/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6

# DataNode
docker run --name pgxl_datanode03 \
-p 15432:15432 \
-e PGNODE=datanode -e PGNAME=pgxl_datanode03 \
-e PGHOST=10.20.0.25 -e PGPORT=6666 \
-v /data/run/docker/pgxl/datanode03/data:/var/lib/postgres \
-d postgres-xl:9.5r1.6
