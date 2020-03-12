#!/bin/sh

#docker build --tag rekgrpth/pgadmin . || exit $?
#docker push rekgrpth/pgadmin || exit $?
docker pull rekgrpth/pgadmin || exit $?
docker volume create pgadmin || exit $?
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
    --name pgadmin \
    --network name=docker \
    --restart always \
    --volume /etc/certs:/etc/certs \
    --volume pgadmin:/home \
    --volume /run/postgresql:/run/postgresql \
    rekgrpth/pgadmin uwsgi --ini pgadmin.ini
