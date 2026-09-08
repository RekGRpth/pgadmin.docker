#!/bin/sh -eux

#docker pull ghcr.io/rekgrpth/pgadmin.docker
docker volume create pgadmin
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop pgadmin || echo $?
docker rm pgadmin || echo $?
export PGADMIN="$(docker volume inspect --format "{{ .Mountpoint }}" pgadmin)"
mkdir -p "$PGADMIN/log"
docker run \
    --detach \
    --env LANG=ru_RU.UTF-8 \
    --env PGADMIN_DEFAULT_EMAIL=container@pgadmin.org \
    --env PGADMIN_DEFAULT_PASSWORD=Conta1ner \
    --env TZ=Asia/Yekaterinburg \
    --hostname pgadmin \
    --mount type=bind,source="$PGADMIN"/log,destination=/var/log/pgadmin \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=volume,source=pgadmin,destination=/var/lib/pgadmin \
    --name pgadmin \
    --network name=docker \
    --restart always \
    ghcr.io/rekgrpth/pgadmin.docker
