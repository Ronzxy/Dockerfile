Docker Official
====

docker 官方映像快捷使用记录

***安装Docker***
```sh
curl -sSL https://get.docker.com | sh
```

*PostgreSQL*:
```sh
# 获取映像
docker pull library/postgres:9.4.5
# 创建并启动
docker run --name postgres_inst1 \
-p 5432:5432 \
-v /data/run/docker/postgres_inst1/data:/var/lib/postgresql/data:rw \
-e POSTGRES_PASSWORD=123456 -d postgres:9.4.5
```

*Percona(MySQL)*:
```sh
# 获取映像
docker pull library/percona:5.6.26
# 创建并启动
docker run --name percona_inst1 \
-p 3306:3306 \
-v /data/run/docker/percona_inst1/data:/var/lib/mysql:rw \
-e MYSQL_ROOT_PASSWORD=123456 -d percona:5.6.26
```

*Tomcat*:
```sh
# 获取映像
docker pull library/tomcat:8-jre8
# 创建并启动
docker run --name tomcat8_inst1 \
-p 8080:8080 \
-v /data/run/docker/tomcat8_inst1/conf/server.xml:/usr/local/tomcat/conf/server.xml \
-v /data/run/docker/tomcat8_inst1/webapps:/usr/local/tomcat/webapps:rw \
-d tomcat:8-jre8

# Tomcat主机配置
<Engine name="Catalina">
      <Host name="openeasy.net" appBase="webapps" autodeploy="true" unpackWARs="true">
        <Context path="" docBase="openeasy"  debug="0" reloadable="true" />
      </Host>

</Engine>
```

*Redis*:
```sh
# 获取映像
docker pull redis:3.0.3
# 创建并启动
docker run --name redis_inst1 \
-p 6379:6379 \
-v /data/run/docker/redis_inst1/data:/data:rw \
-d redis:3.0.3 redis-server --appendonly yes
```
