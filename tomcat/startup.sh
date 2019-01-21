#!/bin/bash

WORK_HOME=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
TOMCAT_NAME="apache-tomcat-${TOMCAT_VERSION}"

if [ -f "${CATALINA_HOME}" ]; then
    mv ${CATALINA_HOME} ${CATALINA_HOME}.$(date +%Y-%m-%d-%H%M%S)
fi

if [ ! -d "${CATALINA_HOME}" ]; then
    mkdir -p ${CATALINA_HOME}
fi

if [ ! -d "${CATALINA_HOME}/bin" ]; then
    if [ ! -d "${TOMCAT_NAME}" ]; then
        tar xf /opt/${TOMCAT_NAME}.tar.gz -C ${CATALINA_HOME}
    fi

    mv ${CATALINA_HOME}/${TOMCAT_NAME}/bin ${CATALINA_HOME}
fi

if [ ! -d "${CATALINA_HOME}/conf" ]; then
    if [ ! -d "${CATALINA_HOME}/${TOMCAT_NAME}" ]; then
        tar xf /opt/${TOMCAT_NAME}.tar.gz -C ${CATALINA_HOME}
    fi

    mv ${CATALINA_HOME}/${TOMCAT_NAME}/conf ${CATALINA_HOME}
fi

if [ ! -d "${CATALINA_HOME}/lib" ]; then
    if [ ! -d "${CATALINA_HOME}/${TOMCAT_NAME}" ]; then
        tar xf /opt/${TOMCAT_NAME}.tar.gz -C ${CATALINA_HOME}
    fi

    mv ${CATALINA_HOME}/${TOMCAT_NAME}/lib ${CATALINA_HOME}
fi

if [ ! -d "${CATALINA_HOME}/webapps" ]; then
    if [ ! -d "${CATALINA_HOME}/${TOMCAT_NAME}" ]; then
        tar xf /opt/${TOMCAT_NAME}.tar.gz -C ${CATALINA_HOME}
    fi

    mv ${CATALINA_HOME}/${TOMCAT_NAME}/webapps ${CATALINA_HOME}
fi

if [ ! -d "${CATALINA_HOME}/logs" ]; then
    mkdir -p ${CATALINA_HOME}/logs
fi

if [ ! -d "${CATALINA_HOME}/temp" ]; then
    mkdir -p ${CATALINA_HOME}/temp
fi

if [ ! -d "${CATALINA_HOME}/work" ]; then
    mkdir -p ${CATALINA_HOME}/work
fi

if [ -d "${CATALINA_HOME}/${TOMCAT_NAME}" ]; then
    rm -rf ${CATALINA_HOME}/${TOMCAT_NAME}
fi

sh ${CATALINA_HOME}/bin/catalina.sh run 2>&1 | /usr/bin/cronolog "${CATALINA_HOME}/logs/${CATALINA_OUT}"
