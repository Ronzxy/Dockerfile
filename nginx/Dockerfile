FROM debian:jessie

MAINTAINER NGINX Docker Maintainers "zhangchaoren@openeasy.net"

RUN echo "deb http://mirrors.163.com/debian/ jessie main" > /etc/apt/sources.list
#RUN echo "deb-src http://mirrors.163.com/debian/ jessie main" >> /etc/apt/sources.list

# 安装依赖包
RUN apt-get update && \
    apt-get install -y gcc g++ make patch libpcre3-dev zlib1g-dev libssl-dev google-perftools/stable

# 添加用户
RUN groupadd -r www && \
    useradd -r -g www www -d /opt/www -s /sbin/nologin
# 创建目录及修改权限
RUN mkdir -p /var/cache/nginx /var/log/nginx && \
    chown -R www:www /var/cache/nginx /var/log/nginx

# 复制数据
COPY nginx/sbin/nginx /usr/sbin/
COPY nginx/etc/nginx /etc/nginx
COPY nginx/html /opt/www

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
