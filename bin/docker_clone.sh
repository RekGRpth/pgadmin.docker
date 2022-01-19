#!/bin/sh -eux

cd "$HOME"
pip install --no-cache-dir --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v$DOCKER_PGADMIN_VERSION/pip/pgadmin4-$DOCKER_PGADMIN_VERSION-py3-none-any.whl"
#cp -rf "$HOME/src/config_local.py" "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/pgadmin4/"
