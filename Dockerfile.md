Dockerfile
==========
Dockerfile是一个镜像的表示，可以通过Dockerfile来描述构建镜像的步骤，并自动构建一个容器。

所有的 Dockerfile 指令格式都是:
```sh
INSTRUCTION arguments
```

虽然指令忽略大小写，但是建议使用大写。

### FROM 指令

```sh
FROM <image>
```
或
```sh
FROM <image>:<tag>
```

这个设置基本的镜像，为后续的指令使用，所以应该作为Dockerfile的第一条指令。

比如:
```sh
FROM ubuntu
```

如果没有指定 tag ，则默认tag是latest，如果都没有则会报错。

### RUN 指令
RUN指令会在上面FROM指定的镜像里执行任何指令，然后提交(commit)结果，提交的镜像会在后面继续用到。

两种格式:
```sh
RUN <command> (the command is run in a shell - `/bin/sh -c`)
```
或:
```sh
RUN ["executable", "param1", "param2" ... ]  (exec form)
```
RUN指令等价于:
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

### MAINTAINER 指令
```sh
MAINTAINER <name>
```
MAINTAINER指令用来指定维护者的姓名和联系方式

如:

```sh
MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"
```

### ENTRYPOINT 指令

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

ENTRYPOINT 指令设置在容器启动时执行指令
```
# cat Dockerfile
FROM debian
ENTRYPOINT echo "Welcome!"

# docker run 62fda5e450d5
Welcome!
```

### USER 指令

比如指定 memcached 的运行用户，可以使用上面的 ENTRYPOINT 来实现:
```sh
ENTRYPOINT ["memcached", "-u", "daemon"]
```
更好的方式是：
```sh
ENTRYPOINT ["memcached"]
USER daemon
```

### EXPOSE 指令

EXPOSE 指令可以设置一个端口在运行的镜像中暴露在外
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

### ENV 指令

用于设置环境变量
```sh
ENV <key> <value>
```
设置了后，后续的RUN指令都可以使用

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

### ADD 指令

ADD指令的功能是将主机构建环境（上下文）目录中的文件和目录、以及一个URL标记的文件拷贝到镜像中。
其格式是：

```sh
ADD <src> <dest>
```

有如下注意事项：

1、如果源路径是个文件，且目标路径是以 / 结尾， 则docker会把目标路径当作一个目录，会把源文件拷贝到该目录下。

如果目标路径不存在，则会自动创建目标路径。

2、如果源路径是个文件，且目标路径是不是以 / 结尾，则docker会把目标路径当作一个文件。

如果目标路径不存在，会以目标路径为名创建一个文件，内容同源文件；

如果目标文件是个存在的文件，会用源文件覆盖它，当然只是内容覆盖，文件名还是目标文件名。

如果目标文件实际是个存在的目录，则会源文件拷贝到该目录下。 注意，这种情况下，最好显示的以 / 结尾，以避免混淆。

3、如果源路径是个目录，且目标路径不存在，则docker会自动以目标路径创建一个目录，把源路径目录下的文件拷贝进来。

如果目标路径是个已经存在的目录，则docker会把源路径目录下的文件拷贝到该目录下。

4、如果源文件是个归档文件（压缩文件），则docker会自动帮解压。

### COPY 指令

COPY指令和ADD指令功能和使用方式类似。只是COPY指令不会做自动解压工作。

### VOLUME 指令
```sh
VOLUME ["<mountpoint>"]
```
如:
```sh
VOLUME ["/data"]
```
创建一个挂载点用于共享目录


### WORKDIR 指令
```sh
WORKDIR /path/to/workdir
```
配置RUN, CMD, ENTRYPOINT 指令设置当前工作路径

可以设置多次，如果是相对路径，则相对前一个 WORKDIR 指令

比如:
```sh
WORKDIR /a WORKDIR b WORKDIR c RUN pwd
```
其实是在 /a/b/c 下执行 pwd

### CMD 指令

有三种格式:
```sh
CMD ["executable","param1","param2"] (like an exec, preferred form)
CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
CMD command param1 param2 (as a shell)
```
一个Dockerfile里只能有一个CMD，如果有多个，只有最后一个生效。

The main purpose of a CMD is to provide defaults for an executing container. These defaults can include an executable, or they can omit the executable, in which case you must specify an ENTRYPOINT as well.

### 总结

基本常用的指令是: FROM, MAINTAINER, RUN, ENTRYPOINT, USER, PORT, ADD

