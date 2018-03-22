#!/bin/sh

if [ "$GROUP_ID" = "" ]; then GROUP_ID=$(id -g "$GROUP"); fi
if [ "$GROUP_ID" != "$(id -g "$GROUP")" ]; then
    find / -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
    groupmod --gid "$GROUP_ID" "$GROUP"
fi

if [ "$USER_ID" = "" ]; then USER_ID=$(id -u "$USER"); fi
if [ "$USER_ID" != "$(id -u "$USER")" ]; then
    find / -user "$USER" -exec chown "$USER_ID" {} \;
    usermod --uid "$USER_ID" "$USER"
fi

PGADMIN="/usr/lib/python3.6/site-packages/pgadmin4"

sed -i "s|'/var/lib/pgadmin'|'$HOME'|gi" "$PGADMIN/config.py"
sed -i "s|'/var/log/pgadmin/pgadmin4.log'|'$HOME/log/pgadmin4.log'|gi" "$PGADMIN/config.py"
#sed -i "/^UPGRADE_CHECK_ENABLED/cUPGRADE_CHECK_ENABLED = False" "$PGADMIN/config.py"
sed -i "/^DEFAULT_SERVER/cDEFAULT_SERVER = '0.0.0.0'" "$PGADMIN/config.py"

test -f "$PGADMIN/pgAdmin4.wsgi" && mv -f "$PGADMIN/pgAdmin4.wsgi" "$PGADMIN/pgAdmin4wsgi.py"
cp -rf "$PGADMIN"/* "$HOME/app"

if [ ! -f "$HOME/pgadmin4.db" ]; then
#    export PGADMIN_SETUP_EMAIL=container@pgadmin.org
#    export PGADMIN_SETUP_PASSWORD=Conta1ner
    python3 "$HOME/app/setup.py"
fi

find "$HOME" ! -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
find "$HOME" ! -user "$USER" -exec chown "$USER_ID" {} \;

exec su-exec "$USER" "$@"
