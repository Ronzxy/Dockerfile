Docker Official
===============

docker 官方映像获取和使用配置



## PostgreSQL ##
*运行PostgreSQL容器*

```sh
IMAGE_VERSION=10.5
# 获取映像
docker pull library/postgres:${IMAGE_VERSION}
# 创建并启动
docker run --name postgres \
-p 5432:5432 \
-v /home/storage/run/docker/postgres/data:/var/lib/postgresql/data:rw \
-e POSTGRES_PASSWORD=123456 \
--restart=always -d postgres:${IMAGE_VERSION}
```

## Percona(MySQL) ##
*运行Percona(MySQL)容器*

```sh
IMAGE_VERSION=5.7.16
# 获取映像
docker pull library/percona:${IMAGE_VERSION}
# 创建并启动
docker run --name percona \
-p 3306:3306 \
-v /home/storage/run/docker/percona/data:/var/lib/mysql:rw \
-e MYSQL_ROOT_PASSWORD=123456 \
--restart=always -d percona:${IMAGE_VERSION}
```

## Tomcat ##
*运行Tomcat容器*

```sh
IMAGE_VERSION=8-jre8
# 获取映像
docker pull library/tomcat:${IMAGE_VERSION}
# 创建并启动
docker run --name tomcat8_jre8 \
-p 8080:8080 \
-v /home/storage/run/docker/tomcat8_jre8/conf/server.xml:/usr/local/tomcat/conf/server.xml \
-v /home/storage/run/docker/tomcat8_jre8/webapps:/usr/local/tomcat/webapps:rw \
--restart=always -d tomcat:${IMAGE_VERSION}
```

*Tomcat主机配置*

```sh
<Engine name="Catalina">
      <Host name="openeasy.net" appBase="webapps" autodeploy="true" unpackWARs="true">
        <Context path="" docBase="openeasy"  debug="0" reloadable="true" />
      </Host>

</Engine>
```

*Tomcat设置JAVA参数*

```sh
JAVA_OPTS="-server  -Dfile.encoding=UTF-8 -Duser.timezone=GMT+08 -Xss2m -Xms1024m -Xmx1024m"
```

## Redis ##
*运行Redis容器*

```sh
IMAGE_VERSION=5.0.0
# 获取映像
docker pull redis:${IMAGE_VERSION}
# 创建并启动
docker run --name redis \
-p 6379:6379 \
-v /home/storage/run/docker/redis/data:/data:rw \
--cpu-shares=256 \
--memory=100m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
-d redis:${IMAGE_VERSION} redis-server --appendonly yes
```

## RabbitMQ ##
*运行RabbitMQ容器*

```sh
IMAGE_VERSION=3.7
# 获取映像
docker pull rabbitmq:${IMAGE_VERSION}-alpine
# 创建并启动
docker run --name rabbitmq \
--hostname rabbitmq \
-p 4369:4369/tcp \
-p 5671-5672:5671-5672/tcp \
-p 25672:25672/tcp \
-v /home/storage/run/docker/rabbitmq/conf:/etc/rabbitmq:rw \
-v /home/storage/run/docker/rabbitmq/data:/var/lib/rabbitmq:rw \
-e RABBITMQ_DEFAULT_USER=rabbit \
-e RABBITMQ_DEFAULT_PASS=Abc123 \
--cpu-shares=256 \
--memory=100m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
-d rabbitmq:${IMAGE_VERSION}-alpine
```

## Mongo ##
*运行Mongo容器*
IMAGE_VERSION=3.6.9
docker pull mongo:${IMAGE_VERSION}-stretch
docker run -d --name mongodb \
-p 27017:27017/tcp \
-e MONGO_INITDB_ROOT_USERNAME=admin \
-e MONGO_INITDB_ROOT_PASSWORD=Abc123 \
--cpu-shares=256 \
--memory=100m --memory-swap=-1 \
--oom-kill-disable=true \
--restart=always \
mongo:${IMAGE_VERSION}-stretch
