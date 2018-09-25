#!/bin/sh

#docker build --tag rekgrpth/pgadmin . || exit $?
#docker push rekgrpth/pgadmin || exit $?
docker stop pgadmin
docker rm pgadmin
docker pull rekgrpth/pgadmin || exit $?
docker volume create pgadmin || exit $?
docker network create my
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname pgadmin \
    --name pgadmin \
    --network my \
    --restart always \
    --volume pgadmin:/data \
    rekgrpth/pgadmin
