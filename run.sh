#!/bin/sh -ex

#docker build --tag rekgrpth/pgadmin .
#docker push rekgrpth/pgadmin
docker pull rekgrpth/pgadmin
docker volume create pgadmin
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop pgadmin || echo $?
docker rm pgadmin || echo $?
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname pgadmin \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=volume,source=pgadmin,destination=/home \
    --name pgadmin \
    --network name=docker \
    --restart always \
    rekgrpth/pgadmin uwsgi --ini pgadmin.ini
