FROM debian:stretch

ENV LC_ALL=zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

RUN echo "deb http://mirrors.163.com/debian/ stretch main" > /etc/apt/sources.list && \
    apt update && \
    apt install -y cronolog locales && \
    apt upgrade -y && \
    apt autoclean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN printf "zh_CN.UTF-8 UTF-8\\n" >> /etc/locale.gen && locale-gen && \
    echo "Asia/Shanghai" > /etc/timezone && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


# JDK、Tomcat
ENV TOMCAT_VERSION=8.5.37
ENV JAVA_VERSION_MAJOR=8
ENV JAVA_VERSION_MINOR=144

ENV CATALINA_HOME=/var/data/tomcat
ENV CATALINA_OUT=catalina.out

ENV JAVA_HOME=/usr/java/default
ENV PATH=$JAVA_HOME/bin:$PATH
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

WORKDIR /

COPY apache-tomcat-${TOMCAT_VERSION}.tar.gz /opt
ADD jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz /usr/java/
COPY startup.sh /

RUN ln -s /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /usr/java/default && \
    mkdir -p ${CATALINA_HOME} && \
    tar xf /opt/apache-tomcat-${TOMCAT_VERSION}.tar.gz -C ${CATALINA_HOME} && \
    mv ${CATALINA_HOME}/apache-tomcat-${TOMCAT_VERSION}/* ${CATALINA_HOME} && \
    rm -rf ${CATALINA_HOME}/apache-tomcat-${TOMCAT_VERSION} && \
    chmod 755 /startup.sh

EXPOSE 8080

CMD ["./startup.sh"]
