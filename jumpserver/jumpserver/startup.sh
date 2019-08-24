#!/bin/bash

if [ ! -f ${JUMPSERVER_HOME}/config.yml ]; then
    ln -sf /usr/bin/python3 /usr/bin/python
    ln -sf /usr/bin/pip3 /usr/bin/pip
    cp -f ${JUMPSERVER_HOME}/config_example.yml  ${JUMPSERVER_HOME}/config.yml

    sed -i "s/SECRET_KEY:/SECRET_KEY: ${SECRET_KEY}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/BOOTSTRAP_TOKEN:/BOOTSTRAP_TOKEN: ${BOOTSTRAP_TOKEN}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/# DEBUG: true/DEBUG: ${DEBUG}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/# LOG_LEVEL: DEBUG/LOG_LEVEL: ${LOG_LEVEL}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/# SESSION_EXPIRE_AT_BROWSER_CLOSE: false/SESSION_EXPIRE_AT_BROWSER_CLOSE: true/g" ${JUMPSERVER_HOME}/config.yml

    sed -i "s/^DB_ENGINE:.*/DB_ENGINE: ${DB_ENGINE}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/^DB_HOST:.*/DB_HOST: ${DB_HOST}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/^DB_PORT:.*/DB_PORT: ${DB_PORT}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/^DB_NAME:.*/DB_NAME: ${DB_NAME}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/^DB_USER:.*/DB_USER: ${DB_USER}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/^DB_PASSWORD:.*/DB_PASSWORD: ${DB_PASSWORD}/g" ${JUMPSERVER_HOME}/config.yml

    sed -i "s/^REDIS_HOST:.*/REDIS_HOST: ${REDIS_HOST}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/^REDIS_PORT:.*/REDIS_PORT: ${REDIS_PORT}/g" ${JUMPSERVER_HOME}/config.yml
    sed -i "s/^.*REDIS_PASSWORD:.*/REDIS_PASSWORD: ${REDIS_PASSWORD}/g" ${JUMPSERVER_HOME}/config.yml

    echo -e "\033[31m 你的SECRET_KEY是 $SECRET_KEY \033[0m"
    echo -e "\033[31m 你的BOOTSTRAP_TOKEN是 $BOOTSTRAP_TOKEN \033[0m"
fi

if [ ! -d ${JUMPSERVER_HOME}/data/luna ]; then
    cp -af ${JUMPSERVER_HOME}/luna ${JUMPSERVER_HOME}/data/luna
fi

chown -R jumpserver:jumpserver ${JUMPSERVER_HOME}

su - jumpserver -c "${JUMPSERVER_HOME}/jms start"

