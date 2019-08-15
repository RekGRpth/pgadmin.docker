#!/bin/sh

#docker build --tag rekgrpth/pgadmin . || exit $?
#docker push rekgrpth/pgadmin || exit $?
docker stop pgadmin
docker rm pgadmin
docker pull rekgrpth/pgadmin || exit $?
docker volume create pgadmin || exit $?
docker network create my
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname pgadmin \
    --link nginx:$(hostname -f) \
    --name pgadmin \
    --network my \
    --restart always \
    --volume pgadmin:/home \
    rekgrpth/pgadmin
