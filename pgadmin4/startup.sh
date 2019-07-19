#!/bin/bash

PGADMIN4_PATH="$(python3 -c 'import os; from pgadmin4 import config; print(os.path.dirname(config.__file__))')"

if [ ! -f ${PGADMIN4_PATH}/config_local.py ]; then

    cp ${PGADMIN4_PATH}/config.py \
        ${PGADMIN4_PATH}/config_local.py
    sed -i "s/^DEFAULT_SERVER =.*/DEFAULT_SERVER = '0.0.0.0'/; \
            s/^MAIL_SERVER.*/MAIL_SERVER = '${MAIL_SERVER}'/; \
            s/^MAIL_PORT.*/MAIL_PORT = ${MAIL_PORT}/; \
            s/^MAIL_USE_SSL.*/MAIL_USE_SSL = ${MAIL_USE_SSL}/; \
            s/^MAIL_USE_TLS.*/MAIL_USE_TLS = ${MAIL_USE_TLS}/; \
            s/^MAIL_USERNAME.*/MAIL_USERNAME = '${MAIL_USERNAME}'/; \
            s/^MAIL_PASSWORD.*/MAIL_PASSWORD = '${MAIL_PASSWORD}'/" ${PGADMIN4_PATH}/config_local.py
    python3 ${PGADMIN4_PATH}/setup.py
fi

exec python3 ${PGADMIN4_PATH}/pgAdmin4.py
