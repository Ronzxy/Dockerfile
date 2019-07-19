docker run --name pgadmin4 \
    -p 5050:5050 \
    -v /home/storage/run/docker/pgadmin4/data:/var/lib/pgadmin \
    -e PGADMIN_SETUP_EMAIL='pgadmin4@pgadmin.org' \
    -e PGADMIN_SETUP_PASSWORD='admin' \
    --cpu-shares=512 --memory=512m --memory-swap=-1 \
    --oom-kill-disable=true \
    -t -i -d pgadmin4:4.10
