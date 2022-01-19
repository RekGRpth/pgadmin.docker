#!/bin/sh -eux

cd "$HOME"
pip install --no-cache-dir --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$DOCKER_PGADMIN_VERSION/pip/pgadmin4-$DOCKER_PGADMIN_VERSION-py3-none-any.whl"
