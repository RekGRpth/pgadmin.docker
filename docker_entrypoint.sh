#!/bin/sh

if [ "$GROUP" != "" ]; then
    if [ "$GROUP_ID" = "" ]; then GROUP_ID=$(id -g "$GROUP"); fi
    if [ "$GROUP_ID" != "$(id -g "$GROUP")" ]; then groupmod --gid "$GROUP_ID" "$GROUP"; fi
fi
if [ "$USER" != "" ]; then
    if [ "$USER_ID" = "" ]; then USER_ID=$(id -u "$USER"); fi
    if [ "$USER_ID" != "$(id -u "$USER")" ]; then usermod --uid "$USER_ID" "$USER"; fi
    if [ ! -f "$HOME/config/pgadmin4.db" ]; then exec su-exec "$USER" python "/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4/setup.py"; fi
    exec su-exec "$USER" "$@"
else
    exec "$@"
fi
