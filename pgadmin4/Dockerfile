FROM debian:stretch

RUN echo "deb http://mirrors.163.com/debian/ stretch main" > /etc/apt/sources.list

# 安装依赖包
RUN apt update && \
    apt install -y python3 python3-pip libpq-dev locales && \
    apt upgrade -y && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

# 配置系统环境
# RUN grep "^zh_CN.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g" /etc/locale.gen && \
#     grep "^en_US.UTF-8 UTF-8$" /etc/locale.gen || sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen && \
#     locale-gen
RUN echo "Asia/Shanghai" >> /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ENV PGADMIN4_VERSION='4.10'
ENV MAIL_SERVER='localhost'
ENV MAIL_PORT='25'
ENV MAIL_USE_SSL='False'
ENV MAIL_USE_TLS='False'
ENV MAIL_USERNAME=''
ENV MAIL_PASSWORD=''
ENV PGADMIN_SETUP_EMAIL='pgadmin4@pgadmin.org'
ENV PGADMIN_SETUP_PASSWORD='admin'

WORKDIR /

# 复制数据
COPY whl/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl

RUN pip3 install pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl

COPY startup.sh /
RUN chmod 755 startup.sh

EXPOSE 5050

CMD ["./startup.sh"]
