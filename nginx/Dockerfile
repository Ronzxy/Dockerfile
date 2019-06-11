FROM debian:stretch

RUN echo "deb http://mirrors.163.com/debian/ stretch main" > /etc/apt/sources.list

# 安装依赖包
RUN apt update && \
    apt install -y libpcre3 zlib1g openssl libjemalloc1 locales && \
    apt upgrade -y && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 配置系统环境
# RUN grep "^zh_CN.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen && \
#     grep "^en_US.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen && \
#     locale-gen
RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 添加用户
RUN groupadd -r -g 1201 www && \
    useradd -r -u 1201 -g www www -m -d /home/www -s /sbin/nologin

WORKDIR /

# 复制数据
COPY dist/nginx-1.16.0 /nginx
COPY startup.sh /

RUN chmod 755 /startup.sh

EXPOSE 80 443

CMD ["./startup.sh"]
