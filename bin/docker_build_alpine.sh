#!/bin/sh -eux

apk update --no-cache
apk upgrade --no-cache
apk add --no-cache --virtual .build-deps \
    g++ \
    gcc \
    git \
    libffi-dev \
    libjpeg-turbo-dev \
    libpq-dev \
    linux-headers \
    make \
    musl-dev \
    openjpeg-dev \
    pcre2-dev \
    pcre-dev \
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
    py3-pip \
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
    py3-wheel \
    py3-wtforms \
    python3-dev \
    zlib-dev \
;
