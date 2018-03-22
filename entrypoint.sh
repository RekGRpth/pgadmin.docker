#!/bin/sh

if [ "$GROUP_ID" = "" ]; then GROUP_ID=$(id -g $GROUP); fi
if [ "$GROUP_ID" != "$(id -g $GROUP)" ]; then
    find / -group $GROUP -exec chgrp "$GROUP_ID" {} \;
    groupmod --gid "$GROUP_ID" $GROUP
fi

if [ "$USER_ID" = "" ]; then USER_ID=$(id -u $USER); fi
if [ "$USER_ID" != "$(id -u $USER)" ]; then
    find / -user $USER -exec chown "$USER_ID" {} \;
    usermod --uid "$USER_ID" $USER
fi

sed -i "s|'/var/lib/pgadmin'|'$HOME'|gi" "/usr/lib/python3.6/site-packages/pgadmin4/config.py"
sed -i "s|'/var/log/pgadmin/pgadmin4.log'|'$HOME/log/pgadmin4.log'|gi" "/usr/lib/python3.6/site-packages/pgadmin4/config.py"
sed -i "/^UPGRADE_CHECK_ENABLED/cUPGRADE_CHECK_ENABLED = False" "/usr/lib/python3.6/site-packages/pgadmin4/config.py"
sed -i "/^DEFAULT_SERVER/cDEFAULT_SERVER = '0.0.0.0'" "/usr/lib/python3.6/site-packages/pgadmin4/config.py"

test -f "/usr/lib/python3.6/site-packages/pgadmin4/pgAdmin4.wsgi" && mv -f "/usr/lib/python3.6/site-packages/pgadmin4/pgAdmin4.wsgi" "/usr/lib/python3.6/site-packages/pgadmin4/pgAdmin4wsgi.py"
cp -rf "/usr/lib/python3.6/site-packages/pgadmin4" "$HOME/pgadmin"

export PGADMIN_SETUP_EMAIL=container@pgadmin.org
export PGADMIN_SETUP_PASSWORD=Conta1ner
su-exec "$USER" python3 "$HOME/setup.py"

exec su-exec "$USER" "$@"
