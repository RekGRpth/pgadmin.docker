#!/bin/sh

#docker build --tag rekgrpth/pgadmin . && \
docker push rekgrpth/pgadmin && \
docker stop pgadmin
docker rm pgadmin
docker pull rekgrpth/pgadmin && \
docker volume create pgadmin && \
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname pgadmin \
    --name pgadmin \
    --publish 4324:4324 \
    --volume pgadmin:/data \
    rekgrpth/pgadmin
