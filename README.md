Dockerfile
==========
Dockerfile是一个镜像的表示，可以通过Dockerfile来描述构建镜像的步骤，并自动构建一个容器。

所有的 Dockerfile 命令格式都是:
```sh
INSTRUCTION arguments
```

虽然指令忽略大小写，但是建议使用大写。

### FROM 命令

```sh
FROM <image>
```
或
```sh
FROM <image>:<tag>
```

这个设置基本的镜像，为后续的命令使用，所以应该作为Dockerfile的第一条指令。

比如:
```sh
FROM ubuntu
```

如果没有指定 tag ，则默认tag是latest，如果都没有则会报错。

### RUN 命令
RUN命令会在上面FROM指定的镜像里执行任何命令，然后提交(commit)结果，提交的镜像会在后面继续用到。

两种格式:
```sh
RUN <command> (the command is run in a shell - `/bin/sh -c`)
```
或:
```sh
RUN ["executable", "param1", "param2" ... ]  (exec form)
```
RUN命令等价于:
```sh
docker run image command
docker commit container_id
```

### 注释

使用 # 作为注释

如:
```sh
# Nginx
#
# VERSION   1.9.9

# Use the debian jessie as base image
FROM debian:jessie

# Make sure the package repository is up to date
RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list
```

### MAINTAINER 命令
```sh
MAINTAINER <name>
```
MAINTAINER命令用来指定维护者的姓名和联系方式

如:

```sh
MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"
```

### ENTRYPOINT 命令

有两种语法格式，一种就是上面的(shell方式):

```sh
ENTRYPOINT cmd param1 param2 ...
```

第二种是 exec 格式:
```sh
ENTRYPOINT ["cmd", "param1", "param2"...]
```

如:
```sh
ENTRYPOINT ["echo", "Whale you be my container"]
```

ENTRYPOINT 命令设置在容器启动时执行命令
```
# cat Dockerfile
FROM debian
ENTRYPOINT echo "Welcome!"

# docker run 62fda5e450d5
Welcome!
```

### USER 命令

比如指定 memcached 的运行用户，可以使用上面的 ENTRYPOINT 来实现:
```sh
ENTRYPOINT ["memcached", "-u", "daemon"]
```
更好的方式是：
```sh
ENTRYPOINT ["memcached"]
USER daemon
```

### EXPOSE 命令

EXPOSE 命令可以设置一个端口在运行的镜像中暴露在外
```sh
EXPOSE <port> [<port>...]
```
比如 Nginx 使用端口 80 和 443 可以把这俩个端口暴露在外，这样容器外可以看到这个端口并与其通信。
```sh
EXPOSE 80 443
```
一个完整的例子:
```sh
# Nginx
#
# VERSION   1.9.9

# Use the debian jessie as base image
FROM debian:jessie

# Make sure the package repository is up to date
RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list

# 安装依赖包
RUN apt-get update && \
    apt-get install -y libpcre3 zlib1g libssl1.0.0 libjemalloc1 && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# 添加用户
RUN groupadd -r www && \
    useradd -r -g www www -d /opt/www -s /sbin/nologin

WORKDIR /

# 复制数据
COPY nginx/sbin/nginx /usr/sbin/
COPY nginx/conf /etc/nginx
COPY nginx/html /usr/html
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 80 443

CMD ["./startup.sh"]
```
Linux 更新镜像，国内建议换成163或sohu的源，不然太慢了。

### ENV 命令

用于设置环境变量
```sh
ENV <key> <value>
```
设置了后，后续的RUN命令都可以使用

使用此dockerfile生成的image新建container，可以通过 docker inspect 看到这个环境变量:
```sh
# docker inspect <container_name>
    ...
    "Env": [
        "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
        "ROOT_DATA=/data"
    ],
    ...
```
里面的GOGS_DATA=/data就是设置的。

也可以通过在docker run时设置或修改环境变量:
```sh
docker run -i -t --env ROOT_DATA=/data debian:jessie /bin/bash
```

### ADD 命令

从src复制文件到container的dest路径:
```sh
ADD <src> <dest>

<src> 是相对被构建的源目录的相对路径，可以是文件或目录的路径，也可以是一个远程的文件url
<dest> 是container中的绝对路径
```

### VOLUME 命令
```sh
VOLUME ["<mountpoint>"]
```
如:
```sh
VOLUME ["/data"]
```
创建一个挂载点用于共享目录


### WORKDIR 命令
```sh
WORKDIR /path/to/workdir
```
配置RUN, CMD, ENTRYPOINT 命令设置当前工作路径

可以设置多次，如果是相对路径，则相对前一个 WORKDIR 命令

比如:
```sh
WORKDIR /a WORKDIR b WORKDIR c RUN pwd
```
其实是在 /a/b/c 下执行 pwd

### CMD 命令

有三种格式:
```sh
CMD ["executable","param1","param2"] (like an exec, preferred form)
CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
CMD command param1 param2 (as a shell)
```
一个Dockerfile里只能有一个CMD，如果有多个，只有最后一个生效。

The main purpose of a CMD is to provide defaults for an executing container. These defaults can include an executable, or they can omit the executable, in which case you must specify an ENTRYPOINT as well.

### 总结

基本常用的命令是: FROM, MAINTAINER, RUN, ENTRYPOINT, USER, PORT, ADD

