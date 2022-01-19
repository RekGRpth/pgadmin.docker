#!/bin/sh -eux

if [ "$(id -u)" = '0' ]; then
    if [ -n "$GROUP" ] && [ -n "$GROUP_ID" ] && [ "$GROUP_ID" != "$(id -g "$GROUP")" ]; then
        test -n "$USER" && usermod --home /tmp "$USER"
        groupmod --gid "$GROUP_ID" "$GROUP"
        chgrp "$GROUP_ID" "$HOME"
        test -n "$USER" && usermod --home "$HOME" "$USER"
    fi
    if [ -n "$USER" ] && [ -n "$USER_ID" ] && [ "$USER_ID" != "$(id -u "$USER")" ]; then
        usermod --home /tmp "$USER"
        usermod --uid "$USER_ID" "$USER"
        chown "$USER_ID" "$HOME"
        usermod --home "$HOME" "$USER"
        if [ ! -f "$HOME/config/pgadmin4.db" ]; then
            gosu "$USER" python "/usr/local/lib/python${DOCKER_PYTHON_VERSION}/site-packages/pgadmin4/setup.py"
        fi
        exec gosu "$USER" "$@"
    fi
fi
exec "$@"
