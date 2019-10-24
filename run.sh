#!/bin/sh

#docker build --tag rekgrpth/pgadmin . || exit $?
#docker push rekgrpth/pgadmin || exit $?
docker stop pgadmin
docker rm pgadmin
docker pull rekgrpth/pgadmin || exit $?
docker volume create pgadmin || exit $?
docker network create --opt com.docker.network.bridge.name=docker docker
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname pgadmin \
    --link nginx:$(hostname -f) \
    --name pgadmin \
    --network docker \
    --restart always \
    --volume pgadmin:/home \
    rekgrpth/pgadmin uwsgi --ini pgadmin.ini
