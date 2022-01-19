#!/bin/sh -eux

cd /
apk add --no-cache --virtual .pgadmin-rundeps \
    postgresql-client \
    py3-alembic \
    py3-authlib \
    py3-bcrypt \
    py3-blinker \
    py3-brotli \
    py3-certifi \
    py3-chardet \
    py3-cryptography \
    py3-dateutil \
    py3-dnspython \
    py3-email-validator \
    py3-flask-babel \
    py3-flask-login \
    py3-flask-wtf \
    py3-greenlet \
    py3-idna \
    py3-ldap3 \
    py3-mako \
    py3-otp \
    py3-paramiko \
    py3-passlib \
    py3-pillow \
    py3-psutil \
    py3-psycopg2 \
    py3-pynacl \
    py3-qrcode \
    py3-requests \
    py3-setuptools \
    py3-simplejson \
    py3-sqlalchemy \
    py3-sqlparse \
    py3-tz \
    py3-urllib3 \
    py3-wtforms \
    su-exec \
    uwsgi-python3 \
    $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
;
find /usr/local/bin -type f -exec strip '{}' \;
find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;
apk del --no-cache .build-deps
