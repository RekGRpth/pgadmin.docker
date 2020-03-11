#!/bin/sh

#docker build --tag rekgrpth/pgadmin . || exit $?
#docker push rekgrpth/pgadmin || exit $?
docker pull rekgrpth/pgadmin || exit $?
docker volume create pgadmin || exit $?
docker network create --attachable --driver overlay docker || echo $?
docker service create \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname pgadmin \
    --mount type=bind,source=/etc/certs,destination=/etc/certs \
    --mount type=volume,source=pgadmin,destination=/home \
    --name pgadmin \
    --network name=docker \
    rekgrpth/pgadmin uwsgi --ini pgadmin.ini
